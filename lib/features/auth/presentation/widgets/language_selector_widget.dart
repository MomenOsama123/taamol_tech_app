import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taamol_tech/core/constants/app_colors.dart' show AppColors;
import 'package:taamol_tech/features/auth/presentation/controllers/language_controller.dart';
import 'package:taamol_tech/features/auth/presentation/screens/onboarding_screen.dart';

void main() {
  runApp(const TkamolTechApp());
}

class TkamolTechApp extends StatelessWidget {
  const TkamolTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LanguageController.currentLocale,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          title: 'Tkamol Tech',
          debugShowCheckedModeBanner: false,
          locale: currentLocale,

          // إعدادات اللغات والاتجاهات (RTL / LTR)
          supportedLocales: const [Locale('ar', ''), Locale('en', '')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: ThemeData(
            primaryColor: AppColors.primaryCyan,
            scaffoldBackgroundColor: AppColors.background,
          ),
          home: const OnboardingScreen(),
        );
      },
    );
  }
}
