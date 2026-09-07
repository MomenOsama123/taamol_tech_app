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

  // Auth Keys (Login & Sign Up)
  static const String loginHeaderTitle = 'loginHeaderTitle';
  static const String loginCorporateHeaderTitle = 'loginCorporateHeaderTitle';
  static const String loginSubtitle = 'loginSubtitle';
  static const String emailOrPhone = 'emailOrPhone';
  static const String emailOrPhoneHint = 'emailOrPhoneHint';
  static const String emailOrPhoneError = 'emailOrPhoneError';
  static const String password = 'password';
  static const String passwordError = 'passwordError';
  static const String forgotPassword = 'forgotPassword';
  static const String dontHaveAccount = 'dontHaveAccount';
  static const String createNewAccount = 'createNewAccount';

  static const String signUpHeaderTitle = 'signUpHeaderTitle';
  static const String signUpCorporateHeaderTitle = 'signUpCorporateHeaderTitle';
  static const String signUpSubtitleIndividual = 'signUpSubtitleIndividual';
  static const String signUpSubtitleCorporate = 'signUpSubtitleCorporate';
  static const String fullName = 'fullName';
  static const String fullNameError = 'fullNameError';
  static const String companyName = 'companyName';
  static const String companyNameError = 'companyNameError';
  static const String taxNumber = 'taxNumber';
  static const String email = 'email';
  static const String emailError = 'emailError';
  static const String phone = 'phone';
  static const String phoneError = 'phoneError';
  static const String passwordMinError = 'passwordMinError';
  static const String createAccountBtn = 'createAccountBtn';

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

    // Account Type & Auth Common
    individualClient: 'حساب أفراد',
    corporateClient: 'شركات ومؤسسات (B2B)',
    alreadyHaveAccount: 'لديك حساب تجاري مسجل بالفعل؟',

    // Auth Translations (Arabic)
    loginHeaderTitle: 'مرحباً بك مجدداً',
    loginCorporateHeaderTitle: 'تسجيل دخول الشركات (B2B)',
    loginSubtitle: 'سجّل الدخول لمتابعة طلباتك ومستلزماتك التقنية',
    emailOrPhone: 'البريد الإلكتروني / رقم الجوال',
    emailOrPhoneHint: 'example@domain.com',
    emailOrPhoneError: 'يرجى إدخال البريد الإلكتروني أو رقم الجوال',
    password: 'كلمة المرور',
    passwordError: 'يرجى إدخال كلمة المرور',
    forgotPassword: 'نسيت كلمة المرور؟',
    dontHaveAccount: 'ليس لديك حساب؟',
    createNewAccount: 'إنشاء حساب جديد',

    signUpHeaderTitle: 'حساب جديد',
    signUpCorporateHeaderTitle: 'إنشاء حساب شركة (B2B)',
    signUpSubtitleIndividual: 'أنشئ حسابك للبدء بالتسوق وشراء مستلزماتك',
    signUpSubtitleCorporate: 'أنشئ حساب مؤسستك للحصول على الفواتير وعروض الأسعار',
    fullName: 'الاسم الكامل',
    fullNameError: 'يرجى إدخال الاسم الكامل',
    companyName: 'اسم الشركة / المؤسسة',
    companyNameError: 'يرجى إدخال اسم الشركة',
    taxNumber: 'الرقم الضريبي (اختياري)',
    email: 'البريد الإلكتروني',
    emailError: 'يرجى إدخال بريد إلكتروني صحيح',
    phone: 'رقم الجوال',
    phoneError: 'يرجى إدخال رقم جوال صحيح',
    passwordMinError: 'كلمة المرور يجب أن تكون 6 خانات على الأقل',
    createAccountBtn: 'إنشاء الحساب',
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

    // Account Type & Auth Common
    individualClient: 'Individual Account',
    corporateClient: 'Corporate & B2B Client',
    alreadyHaveAccount: 'Already have a commercial account?',

    // Auth Translations (English)
    loginHeaderTitle: 'Welcome Back',
    loginCorporateHeaderTitle: 'Corporate Login (B2B)',
    loginSubtitle: 'Log in to manage your orders and tech supplies',
    emailOrPhone: 'Email / Phone Number',
    emailOrPhoneHint: 'example@domain.com',
    emailOrPhoneError: 'Please enter your email or phone number',
    password: 'Password',
    passwordError: 'Please enter your password',
    forgotPassword: 'Forgot Password?',
    dontHaveAccount: "Don't have an account?",
    createNewAccount: 'Create New Account',

    signUpHeaderTitle: 'New Account',
    signUpCorporateHeaderTitle: 'Create Corporate Account (B2B)',
    signUpSubtitleIndividual: 'Create an account to start shopping tech & office supplies',
    signUpSubtitleCorporate: 'Create your business account to obtain tax invoices & official quotes',
    fullName: 'Full Name',
    fullNameError: 'Please enter your full name',
    companyName: 'Company / Organization Name',
    companyNameError: 'Please enter company name',
    taxNumber: 'Tax Number (Optional)',
    email: 'Email Address',
    emailError: 'Please enter a valid email address',
    phone: 'Phone Number',
    phoneError: 'Please enter a valid phone number',
    passwordMinError: 'Password must be at least 6 characters',
    createAccountBtn: 'Create Account',
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