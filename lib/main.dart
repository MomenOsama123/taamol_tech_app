import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TkamolTechApp());
}

class TkamolTechApp extends StatelessWidget {
  const TkamolTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تكامل تيك التجارية - Tkamol Tech',
      debugShowCheckedModeBanner: false,

      // إعدادات الثيم العام للتطبيق المربوط بثوابت الهوية
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cardWhite,
        primaryColor: AppColors.primaryCyan,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryCyan,
          primary: AppColors.primaryCyan,
          secondary: AppColors.primaryGreen,
        ),
      ),

      // نقطة انطلاق التطبيق من شاشة التحميل (Splash Screen)
      home: const SplashScreen(),
    );
  }
}