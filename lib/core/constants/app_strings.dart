import 'package:flutter/material.dart';

/// كلاس المترجم والثوابت النصية الموحد للتطبيق
abstract class AppStrings {
  // ---------------------------------------------------------------------------
  // 1. مفاتيح الترجمة الثابتة (Translation Keys)
  // ---------------------------------------------------------------------------

  // App General
  static const String appNameAr = 'appNameAr';
  static const String appNameEn = 'appNameEn';
  static const String sloganAr = 'sloganAr';
  static const String sloganEn = 'sloganEn';

  // Common Actions
  static const String skip = 'skip';
  static const String next = 'next';
  static const String getStartedProducts = 'getStartedProducts';
  static const String loginText = 'loginText';
  static const String register = 'register';
  static const String back = 'back';

  // Onboarding Slides
  static const String onboardingTitle1 = 'onboardingTitle1';
  static const String onboardingSubtitle1 = 'onboardingSubtitle1';

  static const String onboardingTitle2 = 'onboardingTitle2';
  static const String onboardingSubtitle2 = 'onboardingSubtitle2';

  static const String onboardingTitle3 = 'onboardingTitle3';
  static const String onboardingSubtitle3 = 'onboardingSubtitle3';

  // Account Type & Auth
  static const String individualClient = 'individualClient';
  static const String corporateClient = 'corporateClient';
  static const String alreadyHaveAccount = 'alreadyHaveAccount';

  // ---------------------------------------------------------------------------
  // 2. القواميس النصية للغات (Localized Dictionaries Maps)
  // ---------------------------------------------------------------------------

  static const Map<String, String> ar = {
    // General & App Info
    appNameAr: 'تكامل تيك التجارية',
    appNameEn: 'Tkamol Tech Trading',
    sloganAr: 'شريكك المتكامل للحلول التقنية والمكتبية',
    sloganEn: 'Your Complete Commercial Tech & Office Solutions Partner',

    // Common Actions
    skip: 'تخطي',
    next: 'التالي',
    getStartedProducts: 'ابدأ الآن واستكشف المنتجات',
    loginText: 'تسجيل الدخول (Log In)',
    register: 'إنشاء حساب جديد',
    back: 'رجوع',

    // Onboarding 1
    onboardingTitle1: 'أجهزة الحاسوب واللابتوبات',
    onboardingSubtitle1: 'تصفح أحدث أجهزة الكمبيوتر المحمولة والمكتبية بأسعار تنافسية وحلول مخصصة للشركات والأفراد.',

    // Onboarding 2
    onboardingTitle2: 'الطابعات والأحبار ومستلزمات المكاتب',
    onboardingSubtitle2: 'تأمين كامل لاحتياجات المكاتب والشركات من طابعات متطورة، أحبار أصلية، ومستلزمات القرطاسية.',

    // Onboarding 3
    onboardingTitle3: 'الأدوات المكتبية والقرطاسية وتجهيز الشركات',
    onboardingSubtitle3: 'تجهيز متكامل للمكاتب والشركات بكافة الأدوات المكتبية والقرطاسية بأسعار الجملة وعروض أسعار فورية معتمدة.',

    // Account Type & Auth
    individualClient: 'حساب أفراد',
    corporateClient: 'شركات ومؤسسات (B2B)',
    alreadyHaveAccount: 'لديك حساب تجاري مسجل بالفعل؟',
  };

  static const Map<String, String> en = {
    // General & App Info
    appNameAr: 'تكامل تيك التجارية',
    appNameEn: 'Tkamol Tech Trading',
    sloganAr: 'شريكك المتكامل للحلول التقنية والمكتبية',
    sloganEn: 'Your Complete Commercial Tech & Office Solutions Partner',

    // Common Actions
    skip: 'Skip',
    next: 'Next',
    getStartedProducts: 'Get Started',
    loginText: 'Log In',
    register: 'Register',
    back: 'Back',

    // Onboarding 1
    onboardingTitle1: 'Computers & Laptops',
    onboardingSubtitle1: 'Browse high-performance laptops and workstations at competitive prices for enterprise and personal use.',

    // Onboarding 2
    onboardingTitle2: 'Printers, Toners & Supplies',
    onboardingSubtitle2: 'Complete supply of enterprise printers, 100% genuine toners, and full office stationery.',

    // Onboarding 3
    onboardingTitle3: 'Office Stationery & Corporate Supplies',
    onboardingSubtitle3: 'Full corporate office setup with stationery supplies at wholesale prices and instant approved quotations.',

    // Account Type & Auth
    individualClient: 'Individual Account',
    corporateClient: 'Corporate & B2B Client',
    alreadyHaveAccount: 'Already have a commercial account?',
  };

  // ---------------------------------------------------------------------------
  // 3. دالة الترجمة التلقائية بحسب لغة السياق (Translation Helper)
  // ---------------------------------------------------------------------------

  /// جلب النص المترجم تلقائياً بحسب لغة الجهاز أو السياق
  static String tr(BuildContext context, String key) {
    final Locale currentLocale = Localizations.localeOf(context);
    final isArabic = currentLocale.languageCode == 'ar';

    if (isArabic) {
      return ar[key] ?? key;
    } else {
      return en[key] ?? key;
    }
  }
}