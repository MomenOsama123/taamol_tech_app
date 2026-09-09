import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../products/presentation/pages/main_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final bool isCorporate;
  const SignUpScreen({super.key, this.isCorporate = false});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _companyNameController.dispose();
    _taxNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة إنشاء الحساب باستخدام Supabase Auth
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // تجميع البيانات الإضافية وحفظها في user_metadata
      final Map<String, dynamic> userMetadata = {
        'full_name': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'is_corporate': widget.isCorporate,
      };

      if (widget.isCorporate) {
        userMetadata['company_name'] = _companyNameController.text.trim();
        userMetadata['tax_number'] = _taxNumberController.text.trim();
      }

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: userMetadata,
      );

      if (mounted && response.user != null && response.session != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
        );
      } else if (mounted && response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إنشاء الحساب. تحقق من بريدك الإلكتروني ثم سجّل الدخول.',
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(isCorporate: widget.isCorporate),
          ),
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ غير متوقع: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                      ? AppStrings.tr(
                          context,
                          AppStrings.signUpCorporateHeaderTitle,
                        )
                      : AppStrings.tr(context, AppStrings.signUpHeaderTitle),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepPurple,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isCorporate
                      ? AppStrings.tr(
                          context,
                          AppStrings.signUpSubtitleCorporate,
                        )
                      : AppStrings.tr(
                          context,
                          AppStrings.signUpSubtitleIndividual,
                        ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 28),

                // حقل الاسم الكامل
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(context, AppStrings.fullName),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.primaryCyan,
                    ),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => (val == null || val.trim().isEmpty)
                      ? AppStrings.tr(context, AppStrings.fullNameError)
                      : null,
                ),
                const SizedBox(height: 16),

                // حقول مخصصة للشركات (B2B)
                if (widget.isCorporate) ...[
                  TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      labelText: AppStrings.tr(context, AppStrings.companyName),
                      prefixIcon: const Icon(
                        Icons.business_outlined,
                        color: AppColors.primaryGreen,
                      ),
                      filled: true,
                      fillColor: AppColors.cardWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? AppStrings.tr(context, AppStrings.companyNameError)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _taxNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppStrings.tr(context, AppStrings.taxNumber),
                      prefixIcon: const Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.primaryGreen,
                      ),
                      filled: true,
                      fillColor: AppColors.cardWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(context, AppStrings.email),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.primaryCyan,
                    ),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => (val == null || !val.contains('@'))
                      ? AppStrings.tr(context, AppStrings.emailError)
                      : null,
                ),
                const SizedBox(height: 16),

                // رقم الجوال
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(context, AppStrings.phone),
                    hintText: '5xxxxxxxx',
                    prefixIcon: const Icon(
                      Icons.phone_android_outlined,
                      color: AppColors.primaryCyan,
                    ),
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => (val == null || val.trim().length < 8)
                      ? AppStrings.tr(context, AppStrings.phoneError)
                      : null,
                ),
                const SizedBox(height: 16),

                // كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(context, AppStrings.password),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.primaryCyan,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
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
                  validator: (val) => (val == null || val.length < 6)
                      ? AppStrings.tr(context, AppStrings.passwordMinError)
                      : null,
                ),
                const SizedBox(height: 28),

                // زر التسجيل
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isCorporate
                          ? AppColors.primaryGreen
                          : AppColors.primaryCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            AppStrings.tr(context, AppStrings.createAccountBtn),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // العودة لتسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.tr(context, AppStrings.alreadyHaveAccount),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LoginScreen(isCorporate: widget.isCorporate),
                          ),
                        );
                      },
                      child: Text(
                        AppStrings.tr(context, AppStrings.loginText),
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
