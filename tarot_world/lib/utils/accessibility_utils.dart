// lib/utils/accessibility_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  // 접근성 레이블을 위한 텍스트 정리
  static String cleanTextForAccessibility(String text) {
    return text
        .replaceAll(RegExp(r'[^\w\s가-힣]'), ' ') // 특수문자 제거
        .replaceAll(RegExp(r'\s+'), ' ') // 연속 공백 정리
        .trim();
  }

  // 카드 정보를 접근성 친화적으로 변환
  static String getCardAccessibilityLabel({
    required String cardName,
    required String keywords,
    required bool isReversed,
    required String position,
  }) {
    final orientation = isReversed ? '역방향' : '정방향';
    return '$position 위치의 $cardName 카드, $orientation, 키워드: $keywords';
  }

  // 코인 잔액 접근성 레이블
  static String getCoinBalanceLabel(int balance) {
    return '현재 코인 잔액: $balance개';
  }

  // 진행률 접근성 레이블
  static String getProgressLabel(double progress, String action) {
    final percentage = (progress * 100).round();
    return '$action 진행률: $percentage퍼센트';
  }

  // 버튼 상태 접근성 레이블
  static String getButtonStateLabel(String buttonText, bool isEnabled) {
    final state = isEnabled ? '활성화됨' : '비활성화됨';
    return '$buttonText 버튼, $state';
  }

  // 햅틱 피드백
  static void provideLightHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  static void provideMediumHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  static void provideHeavyHapticFeedback() {
    HapticFeedback.heavyImpact();
  }

  // 성공/실패에 대한 접근성 피드백
  static void announceSuccess(String message) {
    provideMediumHapticFeedback();
    // 스크린 리더에 알림
    SemanticsService.announce(
      '성공: $message',
      TextDirection.ltr,
    );
  }

  static void announceError(String message) {
    provideHeavyHapticFeedback();
    // 스크린 리더에 알림
    SemanticsService.announce(
      '오류: $message',
      TextDirection.ltr,
    );
  }

  static void announceProgress(String message) {
    // 진행 상황을 너무 자주 알리지 않도록 제한
    SemanticsService.announce(
      message,
      TextDirection.ltr,
    );
  }

  // 포커스 관리
  static void requestFocus(FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  // 텍스트 크기 확인
  static bool isLargeTextSize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.textScaler.scale(1.0) > 1.3;
  }

  // 고대비 모드 확인
  static bool isHighContrastMode(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.highContrast;
  }

  // 애니메이션 감소 설정 확인
  static bool isReduceAnimationsEnabled(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.disableAnimations;
  }

  // 접근성 친화적인 애니메이션 지속시간
  static Duration getAccessibleAnimationDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    if (isReduceAnimationsEnabled(context)) {
      return Duration(milliseconds: normalDuration.inMilliseconds ~/ 3);
    }
    return normalDuration;
  }

  // 컬러 대비 개선
  static Color getAccessibleColor(
    BuildContext context,
    Color normalColor,
    Color highContrastColor,
  ) {
    if (isHighContrastMode(context)) {
      return highContrastColor;
    }
    return normalColor;
  }

  // 최소 터치 영역 확보
  static Widget ensureMinimumTouchTarget({
    required Widget child,
    double minSize = 48.0,
  }) {
    return SizedBox(
      width: minSize,
      height: minSize,
      child: child,
    );
  }

  // 접근성 트레이트 설정
  static Map<String, dynamic> getButtonSemantics({
    required String label,
    String? hint,
    bool isEnabled = true,
  }) {
    return {
      'label': label,
      'hint': hint,
      'button': true,
      'enabled': isEnabled,
    };
  }

  static Map<String, dynamic> getCardSemantics({
    required String cardName,
    required String position,
    required bool isReversed,
    String? keywords,
  }) {
    final orientation = isReversed ? '역방향' : '정방향';
    return {
      'label': '$position 위치의 $cardName',
      'hint': '$orientation${keywords != null ? ', 키워드: $keywords' : ''}',
      'image': true,
    };
  }

  // 읽기 순서 관리를 위한 시맨틱 순서
  static int getSemanticSortKey(int order) {
    return order;
  }

  // 접근성 액션 정의
  static Map<String, VoidCallback> getCardActions({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    final actions = <String, VoidCallback>{};
    
    if (onTap != null) {
      actions['tap'] = onTap;
    }
    
    if (onLongPress != null) {
      actions['longPress'] = onLongPress;
    }
    
    return actions;
  }

  // 스크린 크기에 따른 적응적 패딩
  static EdgeInsets getAdaptivePadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeText = isLargeTextSize(context);
    
    if (isLargeText) {
      return const EdgeInsets.all(20.0);
    }
    
    if (mediaQuery.size.width < 600) {
      return const EdgeInsets.all(16.0);
    }
    
    return const EdgeInsets.all(24.0);
  }

  // 텍스트 스타일 확대
  static TextStyle getAccessibleTextStyle(
    BuildContext context,
    TextStyle baseStyle,
  ) {
    if (isLargeTextSize(context)) {
      return baseStyle.copyWith(
        fontSize: (baseStyle.fontSize ?? 14) * 1.2,
        height: (baseStyle.height ?? 1.4) * 1.1,
      );
    }
    return baseStyle;
  }
}