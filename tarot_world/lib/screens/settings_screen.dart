// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 카드 스타일 설정 (메모리 저장)
  static String _selectedCardStyle = 'vintage';

  static String get selectedCardStyle => _selectedCardStyle;

  static void setCardStyle(String style) {
    _selectedCardStyle = style;
  }

  final List<Map<String, dynamic>> _cardStyles = [
    {
      'id': 'vintage',
      'name': '빈티지',
      'description': '클래식하고 우아한 스타일',
      'icon': Icons.auto_awesome,
    },
    {
      'id': 'cartoon',
      'name': '카툰',
      'description': '귀엽고 친근한 스타일',
      'icon': Icons.palette,
    },
  ];

  void _selectCardStyle(String styleId) {
    setState(() {
      setCardStyle(styleId);
    });

    // 스낵바로 변경 완료 알림
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('카드 스타일이 ${_getStyleName(styleId)}로 변경되었습니다'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF9966CC),
      ),
    );
  }

  String _getStyleName(String styleId) {
    final style = _cardStyles.firstWhere((s) => s['id'] == styleId);
    return style['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D1B69),
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D1B69),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카드 스타일 선택 섹션
              const Text(
                '카드 스타일',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                '원하는 타로 카드 디자인을 선택하세요',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              // 스타일 옵션들
              Expanded(
                child: ListView.builder(
                  itemCount: _cardStyles.length,
                  itemBuilder: (context, index) {
                    final style = _cardStyles[index];
                    final isSelected = _selectedCardStyle == style['id'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectCardStyle(style['id']),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF9966CC).withOpacity(0.3)
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF9966CC)
                                    : Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                // 아이콘
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF9966CC)
                                        : Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    style['icon'],
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // 텍스트 정보
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        style['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        style['description'],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 선택 표시
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF9966CC),
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 하단 정보
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white70,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '선택한 스타일은 모든 타로 리딩에서 적용됩니다.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
