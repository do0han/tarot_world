import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'tarot_reading_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Tarot Constellation 메뉴 (서버 데이터와 동일)
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': '오늘의 운세',
      'category': 'tarot_reading',
      'uiType': 'single_card',
      'keyword': null,
      'icon': Icons.today,
    },
    {
      'title': '애정운',
      'category': 'tarot_reading',
      'uiType': 'three_card_spread',
      'keyword': 'love',
      'icon': Icons.favorite,
    },
    {
      'title': '재물운',
      'category': 'tarot_reading',
      'uiType': 'three_card_spread',
      'keyword': 'money',
      'icon': Icons.attach_money,
    },
    {
      'title': '직업/학업운',
      'category': 'tarot_reading',
      'uiType': 'three_card_spread',
      'keyword': 'work',
      'icon': Icons.work,
    },
  ];

  void _navigateToTarotReading(Map<String, dynamic> menuItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TarotReadingScreen(
          uiType: menuItem['uiType'],
          keyword: menuItem['keyword'],
          title: menuItem['title'],
        ),
      ),
    );
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
        title: const Text('Tarot Constellation'),
        backgroundColor: const Color(0xFF2D1B69),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
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
        child: SafeArea(
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

                const Text(
                  '원하는 운세를 선택해보세요',
                  style: TextStyle(
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
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final menuItem = _menuItems[index];
                      return _buildMenuCard(menuItem);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> menuItem) {
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
                  menuItem['icon'],
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  menuItem['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getMenuDescription(menuItem),
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

  String _getMenuDescription(Map<String, dynamic> menuItem) {
    switch (menuItem['keyword']) {
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
