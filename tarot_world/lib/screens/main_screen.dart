import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_config.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'settings_screen.dart';
import 'tarot_reading_screen.dart';

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
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              final hasSettings =
                  appProvider.appConfig?.toolbar.items.isNotEmpty ?? false;
              return hasSettings
                  ? IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: _openSettings,
                    )
                  : const SizedBox.shrink();
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
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9966CC),
                Color(0xFF7A4CAE),
              ],
            ),
          ),
          child: Padding(
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
}
