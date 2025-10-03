// lib/screens/login_screen.dart - 로그인 화면

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  // 자동 로그인 체크
  Future<void> _checkAutoLogin() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn && mounted) {
      final user = await AuthService.getLocalUser();
      if (user != null && mounted) {
        // 사용자가 이미 로그인되어 있으면 메인 화면으로 이동
        _navigateToMainScreen(user);
      }
    }
  }

  // 로그인 처리
  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    
    if (username.isEmpty) {
      setState(() {
        _errorMessage = '사용자명을 입력해주세요';
      });
      return;
    }

    if (username.length < 2) {
      setState(() {
        _errorMessage = '사용자명은 2글자 이상이어야 합니다';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 서버 연결 확인
      final isConnected = await AuthService.testConnection();
      if (!isConnected) {
        throw Exception('서버에 연결할 수 없습니다. 서버가 실행 중인지 확인해주세요.');
      }

      // 로그인 요청
      final user = await AuthService.login(username);
      
      if (mounted) {
        // 새 사용자인 경우 환영 메시지 표시
        if (user.isNewUser) {
          _showWelcomeDialog(user);
        } else {
          _navigateToMainScreen(user);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  // 새 사용자 환영 다이얼로그
  void _showWelcomeDialog(User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.celebration, color: Colors.orange),
              SizedBox(width: 8),
              Text('환영합니다! 🎉'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${user.username}님, 타로 월드에 오신 것을 환영합니다!'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber.shade600),
                    const SizedBox(width: 8),
                    Text('시작 보너스: ${user.coinBalance}코인 지급!'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 무료 질문으로 타로의 세계를 체험해보세요\n'
                '• 광고 시청으로 추가 코인을 받을 수 있습니다\n'
                '• 프리미엄 질문으로 더 자세한 운세를 확인하세요',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToMainScreen(user);
              },
              child: const Text('시작하기'),
            ),
          ],
        );
      },
    );
  }

  // 메인 화면으로 이동
  void _navigateToMainScreen(User user) {
    // AppProvider에 사용자 정보 설정
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setCurrentUser(user);
    
    // 메인 화면으로 교체
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade600,
              Colors.deepPurple.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 영역
                const Icon(
                  Icons.auto_awesome,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                
                // 타이틀
                const Text(
                  'Tarot Constellation',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                
                const Text(
                  '별자리처럼 펼쳐진 타로의 신비한 세계',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // 로그인 폼
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '시작하기',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        
                        // 사용자명 입력
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: '사용자명',
                            hintText: '2글자 이상 입력해주세요',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorText: _errorMessage,
                          ),
                          onSubmitted: (_) => _handleLogin(),
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 8),
                        
                        // 안내 텍스트
                        const Text(
                          '• 처음 로그인 시 자동으로 계정이 생성됩니다\n'
                          '• 신규 가입자에게는 50코인을 드립니다',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // 로그인 버튼
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('로그인 중...'),
                                  ],
                                )
                              : const Text(
                                  '시작하기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 서버 상태 안내
                const Text(
                  '📡 서버 상태를 확인하고 있습니다...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}