import 'package:flutter/material.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/features/admin/pages/admin_dashboard_screen.dart';
import 'package:taamol_tech/features/auth/presentation/screens/login_screen.dart'; // 👈 تأكد من صحة هذا المسار
import '../../../../main.dart';
import 'package:taamol_tech/features/auth/data/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = supabase;

  String userName = 'جاري التحميل...';
  String userEmail = 'جاري التحميل...';
  String userRole = 'مستخدم';
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 🔹 جلب بيانات المستخدم الحالي من Supabase
  Future<void> _fetchUserData() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        userRole = 'مستخدم';
        _isAdmin = false;
        _isLoading = false;
      });

      return;
    }

    try {
      final email = user.email ?? 'لا يوجد بريد إلكتروني';

      final isAdmin = await isCurrentUserAdmin();

      String name = 'مستخدم تعامل';
      String profileEmail = email;

      try {
        final response = await _supabase
            .from('profiles')
            .select('full_name, email')
            .eq('id', user.id)
            .maybeSingle();

        if (response != null) {
          name = response['full_name']?.toString().trim().isNotEmpty == true
              ? response['full_name'].toString()
              : 'مستخدم تعامل';

          if (response['email']?.toString().trim().isNotEmpty == true) {
            profileEmail = response['email'].toString();
          }
        }
      } catch (e) {
        debugPrint('PROFILE DATA ERROR: $e');
      }

      if (!mounted) return;

      setState(() {
        userName = name;
        userEmail = profileEmail;

        _isAdmin = isAdmin;
        userRole = isAdmin ? 'مدير النظام (Admin)' : 'مستخدم';

        _isLoading = false;
      });

      debugPrint('PROFILE: user = ${user.email}');
      debugPrint('PROFILE: isAdmin = $isAdmin');
    } catch (e, stackTrace) {
      debugPrint('PROFILE ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _isAdmin = false;
        userRole = 'مستخدم';
        _isLoading = false;
      });
    }
  }

  // 🔹 تسجيل الخروج
  Future<void> _signOut() async {
    try {
      await _supabase.auth.signOut();
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تسجيل الخروج: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        title: Text(
          isArabic ? 'الملف الشخصي' : 'Profile',
          style: const TextStyle(
            color: AppColors.deepPurple,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // صورة الشخصية (Avatar)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryCyan.withAlpha(30),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // اسم المستخدم
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

                  // البريد الإلكتروني
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // شارة الرتبة (Admin / User)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isAdmin
                          ? Colors.amber.shade100
                          : AppColors.primaryCyan.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userRole,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: userRole.contains('Admin')
                            ? Colors.amber.shade900
                            : AppColors.primaryCyan,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // قائمة الخيارات والخيارات الشخصية
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          icon: Icons.shopping_bag_outlined,
                          title: isArabic ? 'طلباتي' : 'My Orders',
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildProfileTile(
                          icon: Icons.location_on_outlined,
                          title: isArabic ? 'عناوين التوصيل' : 'Addresses',
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildProfileTile(
                          icon: Icons.settings_outlined,
                          title: isArabic ? 'الإعدادات' : 'Settings',
                          onTap: () {},
                        ),
                        if (_isAdmin) ...[
                          const Divider(height: 1),
                          _buildProfileTile(
                            icon: Icons.dashboard_customize_outlined,
                            title: isArabic
                                ? 'لوحة تحكم الأدمن'
                                : 'Admin Dashboard',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminDashboardScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر تسجيل الخروج
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _signOut,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text(
                        isArabic ? 'تسجيل الخروج' : 'Logout',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.deepPurple),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}