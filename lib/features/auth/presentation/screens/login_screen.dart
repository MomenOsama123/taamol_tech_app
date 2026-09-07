import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../products/presentation/pages/main_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isCorporate;
  const LoginScreen({super.key, this.isCorporate = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepPurple),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان والوصف
                Text(
                  widget.isCorporate
                      ? AppStrings.tr(context, AppStrings.loginCorporateHeaderTitle)
                      : AppStrings.tr(context, AppStrings.loginHeaderTitle),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepPurple,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.tr(context, AppStrings.loginSubtitle),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 36),

                // حقل البريد أو الجوال
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(context, AppStrings.emailOrPhone),
                    hintText: AppStrings.tr(context, AppStrings.emailOrPhoneHint),
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryCyan),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.tr(context, AppStrings.emailOrPhoneError);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // حقل كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(context, AppStrings.password),
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryCyan),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.tr(context, AppStrings.passwordError);
                    }
                    return null;
                  },
                ),

                // نسيت كلمة المرور
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      AppStrings.tr(context, AppStrings.forgotPassword),
                      style: const TextStyle(
                        color: AppColors.primaryCyan,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Auth Logic
                        // عند الضغط على زر تسجيل الدخول أو إنشاء الحساب:
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const MainScreen(),
  ),
);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.tr(context, AppStrings.loginText),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // الانتقال لإنشاء حساب
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.tr(context, AppStrings.dontHaveAccount),
                      style: TextStyle(color: Colors.grey[600], fontFamily: 'Tajawal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignUpScreen(isCorporate: widget.isCorporate),
                          ),
                        );
                      },
                      child: Text(
                        AppStrings.tr(context, AppStrings.createNewAccount),
                        style: const TextStyle(
                          color: AppColors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}