import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_colors.dart';

class AuthDialogHelper {
  /// دالة تفحص ما إذا كان المستخدم مسجلاً أم زائراً.
  /// إذا كان مسجلاً، تُنفّذ الإجراء المطلوبة (onAuthenticated).
  /// إذا كان زائراً، تعرض Bottom Sheet لطيفة لطلب تسجيل الدخول.
  static void checkUserAndPerformAction({
    required BuildContext context,
    required VoidCallback onAuthenticated,
  }) {
    // التحقق من وجود مستخدم حالي في Supabase
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser != null) {
      // المستخدم مسجل بالفعل -> تنفيذ الإجراء
      onAuthenticated();
    } else {
      // المستخدم زائر -> عرض نافذة تنبيه للتسجيل
      _showLoginRequiredBottomSheet(context);
    }
  }

  static void _showLoginRequiredBottomSheet(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة التنبيه
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 40,
                  color: AppColors.primaryCyan,
                ),
              ),
              const SizedBox(height: 16),

              // العنوان
              Text(
                isArabic ? 'تسجيل الدخول مطلوب' : 'Login Required',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepPurple,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 10),

              // الرسالة التوضيحية
              Text(
                isArabic
                    ? 'لتتمكن من إتمام هذا الإجراء أو إضافة المنتجات إلى السلة، يرجى تسجيل الدخول أو إنشاء حساب جديد.'
                    : 'To complete this action or add products to cart, please log in or create a new account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontFamily: 'Tajawal',
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // زر الذهاب للتسجيل
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // إغلاق النافذة المنبثقة
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isArabic ? 'تسجيل الدخول / حساب جديد' : 'Log In / Sign Up',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // زر إلغاء / المتابعة كزائر
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  isArabic ? 'إلغاء والمتابعة كزائر' : 'Cancel & Continue as Guest',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}