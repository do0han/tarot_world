import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_config.dart';
import '../providers/app_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    // 위젯 빌드 완료 후 초기화 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    if (!mounted) return;
    
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      await appProvider.initialize();
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // 에러는 AppProvider에서 처리되므로 여기서는 별도 처리 불필요
      print('초기화 중 오류: $e');
    }
  }

  void _navigateToNextScreen() {
    if (_isNavigating) return;
    _isNavigating = true;

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    // 최소 2초 스플래시 표시
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (appProvider.isInitialized) {
        // 온보딩 완료 여부 확인
        if (appProvider.onboardingCompleted) {
          // 온보딩이 완료된 경우 바로 메인 화면으로
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          // 온보딩이 필요한 경우
          final onboardingPages = appProvider.appConfig?.onboardingData;

          if (onboardingPages != null && onboardingPages.isNotEmpty) {
            // 서버에서 받은 온보딩 페이지로 이동
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OnboardingScreen(pages: onboardingPages),
              ),
            );
          } else {
            // 온보딩 페이지가 없으면 더미 데이터 사용
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    OnboardingScreen(pages: _getDummyOnboardingPages()),
              ),
            );
          }
        }
      }
    });
  }

  List<OnboardingPage> _getDummyOnboardingPages() {
    return [
      OnboardingPage(
        page: 1,
        title: "Welcome to Tarot Constellation",
        description: "별자리처럼 펼쳐진 타로의 신비한 세계에 오신 것을 환영합니다",
        imageUrl: "https://example.com/onboarding1.png",
      ),
      OnboardingPage(
        page: 2,
        title: "Choose Your Path",
        description: "과거, 현재, 미래의 운명을 카드를 통해 엿보세요",
        imageUrl: "https://example.com/onboarding2.png",
      ),
      OnboardingPage(
        page: 3,
        title: "Start Your Journey",
        description: "지금 바로 당신만의 타로 여행을 시작해보세요",
        imageUrl: "https://example.com/onboarding3.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B69),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D1B69),
              Color(0xFF1A0E42),
            ],
          ),
        ),
        child: Consumer<AppProvider>(
          builder:
              (BuildContext context, AppProvider appProvider, Widget? child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tarot Constellation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 상태별 UI 표시
                  if (appProvider.hasError) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            appProvider.errorMessage ?? '오류가 발생했습니다',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              appProvider.clearError();
                              _initializeApp();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('다시 시도'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (appProvider.isLoading) ...[
                    const LoadingWidget(
                      message: '타로 카드 데이터를 불러오는 중...',
                    ),
                  ] else if (appProvider.isInitialized) ...[
                    const Text(
                      '데이터 로드 완료!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '카드 ${appProvider.tarotCards.length}장 로드됨',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 32,
                    ),
                  ] else ...[
                    const LoadingWidget(
                      message: '앱을 시작하는 중...',
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
