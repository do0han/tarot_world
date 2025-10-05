// lib/themes/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // 색상 상수
  static const Color primaryPurple = Color(0xFF9966CC);
  static const Color darkPurple = Color(0xFF2D1B69);
  static const Color deepPurple = Color(0xFF1A0E42);
  static const Color lightPurple = Color(0xFFE1BEE7);

  // 라이트 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
      fontFamily: 'NotoSans',
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
        surface: Colors.white,
        onSurface: Colors.black87,
        primary: primaryPurple,
        onPrimary: Colors.white,
        secondary: lightPurple,
        onSecondary: Colors.black87,
        error: Colors.red.shade600,
        onError: Colors.white,
      ),

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        shadowColor: Colors.black26,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 카드 테마
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // 다이얼로그 테마
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),

      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade800,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // 접근성 설정
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // 다크 테마
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      fontFamily: 'NotoSans',
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.dark,
        surface: darkPurple,
        onSurface: Colors.white,
        primary: primaryPurple,
        onPrimary: Colors.white,
        secondary: lightPurple,
        onSecondary: Colors.black87,
        error: Colors.red.shade400,
        onError: Colors.white,
      ),

      // 배경 그라데이션용 색상들
      scaffoldBackgroundColor: darkPurple,

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // 카드 테마
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.1),
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),

      // 다이얼로그 테마
      dialogTheme: DialogTheme(
        backgroundColor: darkPurple,
        elevation: 8,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),

      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade800,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // 접근성 설정
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // 고대비 접근성 테마 (시각 장애인을 위한)
  static ThemeData get highContrastTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.yellow,
      fontFamily: 'NotoSans',
      
      colorScheme: const ColorScheme.dark(
        primary: Colors.yellow,
        onPrimary: Colors.black,
        secondary: Colors.cyan,
        onSecondary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),

      // 고대비 텍스트 스타일
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
        bodySmall: TextStyle(color: Colors.white, fontSize: 14),
        labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        labelSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),

      // 고대비 버튼
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}