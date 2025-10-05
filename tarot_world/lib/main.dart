import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'themes/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          // 접근성 설정 자동 감지
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final mediaQuery = MediaQuery.of(context);
            appProvider.updateAccessibilityFromMediaQuery(mediaQuery);
          });

          return MaterialApp(
            title: 'Tarot Constellation',
            debugShowCheckedModeBanner: false,
            
            // 테마 설정
            theme: appProvider.isHighContrastMode 
                ? AppTheme.highContrastTheme 
                : AppTheme.lightTheme,
            darkTheme: appProvider.isHighContrastMode 
                ? AppTheme.highContrastTheme 
                : AppTheme.darkTheme,
            themeMode: appProvider.themeMode,
            
            // 접근성 설정
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  disableAnimations: appProvider.reduceAnimations,
                ),
                child: child!,
              );
            },
            
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
