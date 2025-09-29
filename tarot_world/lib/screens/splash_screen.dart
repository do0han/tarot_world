import 'package:flutter/material.dart';
import '../models/app_config.dart';
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 2초 로딩 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // 온보딩 화면으로 이동 (임시 데이터)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(
            pages: _getDummyOnboardingPages(),
          ),
        ),
      );
    }
  }

  void _navigateToNextScreen() {
    // 사용하지 않음 - _initializeApp에서 직접 처리
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 30),
              Text(
                'Tarot Constellation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '앱을 시작하는 중...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
