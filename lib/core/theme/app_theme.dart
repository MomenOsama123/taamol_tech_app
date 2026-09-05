import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  /// الثيم الفاتح (Light Theme) الأساسي للتطبيق
  static ThemeData get 
  lightTheme {
    return ThemeData(
      // 1. الألوان الأساسية والخلفية
      scaffoldBackgroundColor: AppColors.background, // خلفية التطبيق الرمادية الفاتحة
      primaryColor: AppColors.primaryCyan, // اللون الأساسي للتطبيق[cite: 1]
      
      // إعداد نظام الألوان (Color Scheme) ليتوافق مع تصميم Material 3
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryCyan,
        secondary: AppColors.primaryGreen,
        surface: AppColors.cardWhite,
        error: AppColors.errorRed,
      ),

      // 2. الخطوط (Typography)
      // نستخدم Tajawal كخط أساسي للتطبيق العربي/الإنجليزي (حسب الهوية)[cite: 1]
      fontFamily: 'Tajawal', 

      // 3. تصميم شريط الهيدر (AppBar Theme)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepPurple, // شريط علوي باللون البنفسجي الداكن[cite: 1]
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),

      // 4. تصميم الأزرار الأساسية (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryCyan, // لون أزرار الـ CTA[cite: 1]
          foregroundColor: Colors.white, // لون النص داخل الزر
          elevation: 0,
          minimumSize: const Size(double.infinity, 52), // ارتفاع الزر
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // حواف دائرية ناعمة[cite: 1]
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),

      // 5. تصميم البطاقات (Card Theme)
      cardTheme: CardThemeData(
        color: AppColors.cardWhite, // لون البطاقات أبيض ناصع[cite: 1]
        elevation: 2, // ظل خفيف (Soft Drop Shadow)[cite: 1]
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // حواف البطاقات[cite: 1]
        ),
        margin: EdgeInsets.zero,
      ),

      // 6. تصميم حقول الإدخال (Input Decoration / TextFields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryCyan, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
  }
} 