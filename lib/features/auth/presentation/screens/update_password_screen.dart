import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/widgets/custom_button.dart';
import 'package:taamol_tech/core/widgets/custom_text_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text.trim()),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث كلمة المرور بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'كلمة المرور الجديدة' : 'New Password',
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
                      ? 'أدخل كلمة المرور الجديدة لحسابك'
                      : 'Enter your new password below',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _passwordController,
                  labelText: isArabic ? 'كلمة المرور الجديدة' : 'New Password',
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return isArabic
                          ? 'يرجى إدخال كلمة المرور'
                          : 'Enter password';
                    }
                    if (val.trim().length < 6) {
                      return isArabic
                          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                          : 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: isArabic
                      ? 'تأكيد كلمة المرور'
                      : 'Confirm Password',
                  obscureText: true,
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return isArabic
                          ? 'كلمتا المرور غير متطابقتين'
                          : 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                CustomButton(
                  onPressed: _updatePassword,
                  isLoading: _isLoading,
                  label: isArabic ? 'تحديث كلمة المرور' : 'Update Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
