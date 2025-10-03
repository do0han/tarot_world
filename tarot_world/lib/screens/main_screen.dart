import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_config.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/coin_balance_widget.dart';
import 'settings_screen.dart';
import 'tarot_reading_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 메뉴 아이콘 매핑
  final Map<String, IconData> _iconMap = {
    'today': Icons.today,
    'love': Icons.favorite,
    'money': Icons.attach_money,
    'work': Icons.work,
    'default': Icons.auto_awesome,
  };

  void _navigateToTarotReading(MenuItem menuItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TarotReadingScreen(
          uiType: menuItem.uiType ?? 'single_card',
          keyword: menuItem.keyword,
          title: menuItem.title,
        ),
      ),
    );
  }

  IconData _getMenuIcon(String? keyword) {
    return _iconMap[keyword] ?? _iconMap['default']!;
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            return Text(appProvider.appConfig?.name ?? 'Tarot Constellation');
          },
        ),
        backgroundColor: const Color(0xFF2D1B69),
        foregroundColor: Colors.white,
        actions: [
          // 코인 잔액 표시
          const CoinBalanceAppBarWidget(),
          const SizedBox(width: 8),
          
          // 로그아웃 버튼
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle),
                onSelected: (value) async {
                  if (value == 'logout') {
                    await _handleLogout(appProvider);
                  } else if (value == 'settings') {
                    _openSettings();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'user_info',
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appProvider.currentUser?.username ?? '사용자',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${appProvider.currentUser?.coinBalance ?? 0} 코인',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8),
                        Text('설정'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('로그아웃', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D1B69),
              Color(0xFF1A0E3D),
            ],
          ),
        ),
        child: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            if (appProvider.isLoading) {
              return const LoadingWidget(
                message: '메뉴 데이터를 불러오는 중...',
              );
            }

            if (appProvider.hasError) {
              return ErrorDisplayWidget(
                message: '메뉴를 불러올 수 없습니다',
                details: appProvider.errorMessage,
                onRetry: () => appProvider.refresh(),
              );
            }

            final menuItems = appProvider.appConfig?.menus ?? [];

            if (menuItems.isEmpty) {
              return const Center(
                child: Text(
                  '메뉴 데이터가 없습니다',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 환영 메시지
                    const Text(
                      '별자리처럼 펼쳐진\n타로의 신비한 세계',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${menuItems.length}가지 운세를 선택해보세요',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 메뉴 그리드
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final menuItem = menuItems[index];
                          return _buildMenuCard(menuItem);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(MenuItem menuItem) {
    final isFree = menuItem.isFree ?? true;
    final requiredCoins = menuItem.requiredCoins ?? 0;
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToTarotReading(menuItem),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isFree 
                ? [
                    const Color(0xFF4CAF50), // 무료는 녹색
                    const Color(0xFF2E7D32),
                  ]
                : [
                    const Color(0xFF9966CC), // 유료는 보라색
                    const Color(0xFF7A4CAE),
                  ],
            ),
          ),
          child: Stack(
            children: [
              // 메인 콘텐츠
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getMenuIcon(menuItem.keyword),
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      menuItem.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      menuItem.description ?? _getMenuDescription(menuItem.keyword),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // 무료/유료 배지
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFree ? Colors.green.shade100 : Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isFree ? Colors.green.shade300 : Colors.amber.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFree ? Icons.free_breakfast : Icons.monetization_on,
                        size: 12,
                        color: isFree ? Colors.green.shade700 : Colors.amber.shade700,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        isFree ? '무료' : '$requiredCoins',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isFree ? Colors.green.shade700 : Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMenuDescription(String? keyword) {
    switch (keyword) {
      case 'love':
        return '과거-현재-미래 사랑운';
      case 'money':
        return '과거-현재-미래 재물운';
      case 'work':
        return '과거-현재-미래 직업운';
      default:
        return '오늘 하루 운세';
    }
  }

  // 로그아웃 처리
  Future<void> _handleLogout(AppProvider appProvider) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말로 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await appProvider.logout();
      
      // 로그인 화면으로 이동
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
