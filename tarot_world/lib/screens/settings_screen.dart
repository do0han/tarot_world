// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_config.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../utils/accessibility_utils.dart';

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

    // 햅틱 피드백
    AccessibilityUtils.provideLightHapticFeedback();

    // 스낵바로 변경 완료 알림
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('카드 스타일이 ${_getStyleName(styleId)}로 변경되었습니다'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF9966CC),
      ),
    );
  }

  void _changeThemeMode(ThemeMode mode, AppProvider appProvider) {
    appProvider.setThemeMode(mode);
    AccessibilityUtils.provideLightHapticFeedback();
    
    String modeName = _getThemeModeName(mode);
    AccessibilityUtils.announceSuccess('테마가 $modeName로 변경되었습니다');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('테마가 $modeName로 변경되었습니다'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleAccessibilityOption(String option, bool value, AppProvider appProvider) {
    switch (option) {
      case 'highContrast':
        appProvider.setHighContrastMode(value);
        break;
      case 'reduceAnimations':
        appProvider.setReduceAnimations(value);
        break;
    }
    
    AccessibilityUtils.provideLightHapticFeedback();
    String optionName = option == 'highContrast' ? '고대비 모드' : '애니메이션 감소';
    String status = value ? '활성화' : '비활성화';
    AccessibilityUtils.announceSuccess('$optionName $status');
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '라이트 테마';
      case ThemeMode.dark:
        return '다크 테마';
      case ThemeMode.system:
        return '시스템 설정';
    }
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

  Widget _buildThemeSection(AppProvider appProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '테마 설정',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '앱의 테마를 선택하세요',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        
        // 테마 모드 선택
        ..._buildThemeOptions(appProvider),
      ],
    );
  }

  List<Widget> _buildThemeOptions(AppProvider appProvider) {
    final themes = [
      (ThemeMode.system, '시스템 설정', Icons.settings_system_daydream, '기기 설정을 따라갑니다'),
      (ThemeMode.light, '라이트 모드', Icons.light_mode, '밝은 테마'),
      (ThemeMode.dark, '다크 모드', Icons.dark_mode, '어두운 테마'),
    ];

    return themes.map((theme) {
      final (mode, title, icon, description) = theme;
      final isSelected = appProvider.themeMode == mode;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _changeThemeMode(mode, appProvider),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Theme.of(context).colorScheme.surface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary 
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAccessibilitySection(AppProvider appProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '접근성 설정',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '더 나은 사용자 경험을 위한 설정',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        
        // 고대비 모드
        _buildAccessibilityToggle(
          title: '고대비 모드',
          description: '더 선명한 색상 대비로 가독성을 높입니다',
          icon: Icons.contrast,
          value: appProvider.isHighContrastMode,
          onChanged: (value) => _toggleAccessibilityOption('highContrast', value, appProvider),
        ),
        
        const SizedBox(height: 12),
        
        // 애니메이션 감소
        _buildAccessibilityToggle(
          title: '애니메이션 감소',
          description: '멀미나 집중력 저하를 방지합니다',
          icon: Icons.animation,
          value: appProvider.reduceAnimations,
          onChanged: (value) => _toggleAccessibilityOption('reduceAnimations', value, appProvider),
        ),
      ],
    );
  }

  Widget _buildAccessibilityToggle({
    required String title,
    required String description,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
            activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStyleSection(List<CardStyle> availableStyles, String selectedStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카드 스타일',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${availableStyles.length}가지 타로 카드 디자인 중 선택하세요',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        
        // 스타일 옵션들
        ...availableStyles.map((style) {
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
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                        : Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
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
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getStyleIcon(style.id),
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 텍스트 정보
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              style.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 선택 표시
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        
        // 하단 정보
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '선택한 스타일은 모든 타로 리딩에서 적용됩니다.\n현재 선택: ${_getStyleName(selectedStyle)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.isLoading) {
            return const LoadingWidget(
              message: '스타일 데이터를 불러오는 중...',
              type: LoadingType.standard,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 테마 설정 섹션
                  _buildThemeSection(appProvider),
                  
                  const SizedBox(height: 32),
                  
                  // 접근성 설정 섹션
                  _buildAccessibilitySection(appProvider),
                  
                  const SizedBox(height: 32),
                  
                  // 카드 스타일 선택 섹션
                  _buildCardStyleSection(availableStyles, selectedStyle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
