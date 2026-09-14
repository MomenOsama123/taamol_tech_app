import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/features/auth/presentation/pages/settings_screen.dart';
import 'package:taamol_tech/features/auth/presentation/screens/login_screen.dart';
import 'package:taamol_tech/features/products/presentation/pages/add_edit_product_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = Supabase.instance.client.auth.currentUser;

  String userName = "";
  String userId = "";
  String userRole = "User";
  String userEmail = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _fetchUserProfile();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('full_name, email, is_admin')
          .eq('id', currentUser!.id)
          .maybeSingle();

      if (response != null && mounted) {
        final dynamic rawIsAdmin = response['is_admin'];
        final bool isAdmin =
            rawIsAdmin == true ||
            rawIsAdmin.toString().toLowerCase() == 'true' ||
            rawIsAdmin == 1;

        setState(() {
          userName =
              response['full_name'] ??
              currentUser?.email?.split('@').first ??
              'مستخدم';
          userEmail = response['email'] ?? currentUser?.email ?? '';
          userId = currentUser!.id.substring(0, 8).toUpperCase();
          userRole = isAdmin ? 'Admin' : 'User';
          isLoading = false;
        });
      } else {
        _setFallbackUserData();
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      if (mounted) {
        _setFallbackUserData();
      }
    }
  }

  void _setFallbackUserData() {
    setState(() {
      userName =
          currentUser?.userMetadata?['full_name'] ??
          currentUser?.email?.split('@').first ??
          'مستخدم';
      userEmail = currentUser?.email ?? '';
      userId = currentUser?.id.substring(0, 8).toUpperCase() ?? '';
      userRole = 'User';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final bool isGuest = currentUser == null;
    final bool isAdmin = userRole.toLowerCase() == 'admin';

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.deepPurple),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  isGuest ? _buildGuestHeader(isArabic) : _buildUserHeader(),
                  const SizedBox(height: 24),

                  if (!isGuest && isAdmin) ...[
                    _buildSectionTitle(
                      isArabic
                          ? 'أدوات الإدارة (Admin Panel)'
                          : 'Admin Control Panel',
                    ),
                    const SizedBox(height: 12),
                    _buildAdminSection(isArabic),
                    const SizedBox(height: 24),
                  ],

                  _buildSectionTitle(
                    isArabic
                        ? 'الإعدادات والتفضيلات'
                        : 'Settings & Preferences',
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.settings_outlined,
                            color: AppColors.primaryCyan,
                          ),
                          title: Text(
                            isArabic ? 'الإعدادات' : 'Settings',
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle(
                    isArabic ? 'الدعم والمساعدة' : 'Support & Help',
                  ),
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

                  if (!isGuest)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // 1. تنفيذ عملية تسجيل الخروج غير المتزامنة
                          await Supabase.instance.client.auth.signOut();

                          // 2. التحقق من أن الودجت ما زالت نشطة (موجودة على الشاشة) قبل استخدام الـ context
                          if (!mounted) return;

                          // 3. التنقل بأمان تام
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
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

  Widget _buildAdminSection(bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.deepPurple.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.add_shopping_cart,
              color: AppColors.deepPurple,
            ),
            title: Text(
              isArabic ? 'إضافة منتج جديد' : 'Add New Product',
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditProductScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

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
                backgroundColor: AppColors.primaryCyan.withValues(alpha: 0.15),
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
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColors.deepPurple;
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
}
