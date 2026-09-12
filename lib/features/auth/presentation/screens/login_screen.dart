import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/features/home/presentation/pages/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isCompanyAccount = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة تسجيل الدخول الربطية مع Supabase
  // دالة تسجيل الدخول عبر Supabase
Future<void> _handleLogin() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    // 1. إرسال البريد وكلمة المرور إلى Supabase Auth
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // 2. عند نجاح التسجيل، الانتقال المباشر للواجهة الرئيسية MainScreen
    if (response.user != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    }
  } on AuthException catch (error) {
    if (mounted) {
      _showSnackBar(error.message, isError: true);
    }
  } catch (error) {
    if (mounted) {
      _showSnackBar('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً', isError: true);
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green,
      ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. عنوان الشاشة
                Text(
                  isArabic ? 'مرحباً بعودتك 👋' : 'Welcome Back 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepPurple,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic
                      ? 'قم بتسجيل الدخول لمتابعة المشتريات وعروض الأسعار'
                      : 'Log in to manage purchases & quotations',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 30),

                // 2. خيار نوع الحساب (أفراد / شركات B2B)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isCompanyAccount = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !_isCompanyAccount ? AppColors.primaryCyan : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                isArabic ? 'حساب أفراد' : 'Personal Account',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: !_isCompanyAccount ? Colors.white : AppColors.deepPurple,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isCompanyAccount = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isCompanyAccount ? AppColors.deepPurple : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                isArabic ? 'حساب شركات (B2B)' : 'Corporate (B2B)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _isCompanyAccount ? Colors.white : AppColors.deepPurple,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. حقل البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return isArabic ? 'يرجى إدخال البريد الإلكتروني' : 'Enter email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryCyan),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. حقل كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return isArabic ? 'يرجى إدخال كلمة المرور' : 'Enter password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: isArabic ? 'كلمة المرور' : 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryCyan),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 5. زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isCompanyAccount ? AppColors.deepPurple : AppColors.primaryCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isArabic ? 'تسجيل الدخول' : 'Log In',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // 6. زر المتابعة كزائر
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      isArabic ? 'المتابعة كزائر' : 'Continue as Guest',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}