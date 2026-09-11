import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/controllers/language_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // جلب المستخدم الحالي من Supabase
  User? currentUser = Supabase.instance.client.auth.currentUser;

  // بيانات افتراضية للمستخدم المسجل
  String userName = "أحمد المحمدي";
  String userId = "TK-89420";
  String userRole = "Admin";
  String userEmail = "ahmed@tkamol.com";

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final bool isGuest =
        currentUser == null; // تحديد ما إذا كان المستخدم زائراً

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        title: Text(
          isArabic ? 'الملف الشخصي' : 'User Profile',
          style: const TextStyle(
            color: AppColors.deepPurple,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. عرض بطاقة الزائر أو بطاقة المستخدم المسجل
            isGuest ? _buildGuestHeader(isArabic) : _buildUserHeader(),
            const SizedBox(height: 24),

            // 2. قائمة الإعدادات والتفضيلات (متاحة للجميع)
            _buildSectionTitle(
              isArabic ? 'الإعدادات والتفضيلات' : 'Settings & Preferences',
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // تغيير اللغة
                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      color: AppColors.primaryCyan,
                    ),
                    title: Text(
                      isArabic ? 'اللغة / Language' : 'Language / اللغة',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      isArabic ? 'العربية' : 'English',
                      style: const TextStyle(
                        color: AppColors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      LanguageController.toggleLanguage();
                      setState(() {});
                    },
                  ),

                  // تبديل الأدوار (يظهر للمسجلين فقط للتجربة)
                  if (!isGuest) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: AppColors.deepPurple,
                      ),
                      title: Text(
                        isArabic
                            ? 'تبديل الصلاحية (للتجربة)'
                            : 'Switch Role (Testing)',
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        isArabic ? 'الحالية: $userRole' : 'Current: $userRole',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: _showRoleSwitchDialog,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. الدعم والمساعدة
            _buildSectionTitle(isArabic ? 'الدعم والمساعدة' : 'Support & Help'),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.support_agent,
                  color: AppColors.primaryGreen,
                ),
                title: Text(
                  isArabic ? 'التواصل مع الدعم الفني' : 'Contact Support',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 32),

            // 4. زر تسجيل الخروج للمستخدم المسجل
            if (!isGuest)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: Text(
                    isArabic ? 'تسجيل الخروج' : 'Log Out',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✨ بطاقة خاصة بالحالة عندما يكون المستخدم زائراً (Guest Mode)
  Widget _buildGuestHeader(bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(
              Icons.person_outline_rounded,
              size: 45,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isArabic ? 'مرحباً بك يا زائرنا العزيز 👋' : 'Welcome Guest 👋',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isArabic
                ? 'قم بتسجيل الدخول للاستفادة من حفظ السلة، متابعة عروض الأسعار، وإدارة حسابك.'
                : 'Log in to save items, track quote requests, and manage your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
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
        ],
      ),
    );
  }

  // بطاقة بيانات المستخدم المسجل
  Widget _buildUserHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.primaryCyan.withValues(alpha:0.15),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.deepPurple,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRoleColor(userRole),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  userRole,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.badge_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  'ID: $userId',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepPurple,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return AppColors.deepPurple;
      case 'B2B Corporate':
        return AppColors.primaryGreen;
      default:
        return AppColors.primaryCyan;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  void _showRoleSwitchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'اختر الصلاحية لتجربتها',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Admin (آدمن)'),
              onTap: () {
                setState(() => userRole = 'Admin');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('B2B Corporate (شركة)'),
              onTap: () {
                setState(() => userRole = 'B2B Corporate');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('User (عميل أفراد)'),
              onTap: () {
                setState(() => userRole = 'User');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
