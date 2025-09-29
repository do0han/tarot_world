// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_config.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 스타일 아이콘 매핑
  final Map<String, IconData> _styleIcons = {
    'vintage': Icons.auto_awesome,
    'cartoon': Icons.palette,
    'modern': Icons.design_services,
    'default': Icons.style,
  };

  void _selectCardStyle(String styleId) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setCardStyle(styleId);

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
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final style = appProvider.availableStyles.firstWhere(
      (s) => s.id == styleId,
      orElse: () => CardStyle(id: styleId, name: styleId, description: ''),
    );
    return style.name;
  }

  IconData _getStyleIcon(String styleId) {
    return _styleIcons[styleId] ?? _styleIcons['default']!;
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
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.isLoading) {
            return const LoadingWidget(
              message: '스타일 데이터를 불러오는 중...',
            );
          }

          if (appProvider.hasError) {
            return ErrorDisplayWidget(
              message: '스타일 정보를 불러올 수 없습니다',
              details: appProvider.errorMessage,
              onRetry: () => appProvider.refresh(),
            );
          }

          final availableStyles = appProvider.availableStyles;
          final selectedStyle = appProvider.selectedCardStyle;

          if (availableStyles.isEmpty) {
            return const Center(
              child: Text(
                '사용 가능한 카드 스타일이 없습니다',
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

                  Text(
                    '${availableStyles.length}가지 타로 카드 디자인 중 선택하세요',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 스타일 옵션들
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableStyles.length,
                      itemBuilder: (context, index) {
                        final style = availableStyles[index];
                        final isSelected = selectedStyle == style.id;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _selectCardStyle(style.id),
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
                                        _getStyleIcon(style.id),
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
                                            style.name,
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
                                            style.description,
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '선택한 스타일은 모든 타로 리딩에서 적용됩니다.\n현재 선택: ${_getStyleName(selectedStyle)}',
                            style: const TextStyle(
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
          );
        },
      ),
    );
  }
}
