import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/pages/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _navigateToMain() {
    // الانتقال للشاشة الرئيسية والتخلص من صفحات التسجيل في الـ Stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepPurple),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. عنوان الشاشة
              Text(
                isArabic ? 'تسجيل الدخول' : 'Log In',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepPurple,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 24),

              // 2. حقول إدخال البريد والكلمة السرية
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'البريد الإلكتروني' : 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isArabic ? 'كلمة المرور' : 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. زر تسجيل الدخول
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // كود تسجيل الدخول عبر Supabase هنا
                    _navigateToMain();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isArabic ? 'تسجيل الدخول' : 'Log In',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // -------------------------------------------------------------
              // 4. ✨ زر المتابعة كزائر (Continue as Guest)
              // -------------------------------------------------------------
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      isArabic ? 'أو' : 'OR',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              OutlinedButton(
                onPressed:
                    _navigateToMain, // ينقله للواجهة الرئيسية مباشرة بدون حساب
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.deepPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: AppColors.deepPurple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArabic
                          ? 'المتابعة كزائر (تصفح المنتجات)'
                          : 'Continue as Guest',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepPurple,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
