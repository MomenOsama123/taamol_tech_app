import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/language_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final String currentLang = isArabic ? 'العربية' : 'English';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isArabic ? 'الإعدادات' : 'Settings',
          style: const TextStyle(
            color: AppColors.deepPurple,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.deepPurple),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. قسم التفضيلات العامة
          _buildSectionHeader(isArabic ? 'التفضيلات العامة' : 'General Preferences'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // لغة التطبيق
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primaryCyan),
                  title: Text(
                    isArabic ? 'لغة التطبيق / Language' : 'App Language',
                    style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  trailing: Text(
                    currentLang,
                    style: const TextStyle(color: AppColors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    LanguageController.toggleLanguage();
                    setState(() {});
                  },
                ),
                const Divider(height: 1),

                // الإشعارات
                ListTile(
                  leading: const Icon(Icons.notifications_outlined, color: AppColors.primaryCyan),
                  title: Text(
                    isArabic ? 'الإشعارات والتنبيهات' : 'Notifications',
                    style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    activeThumbColor: AppColors.primaryCyan,
                    onChanged: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. قسم حول التطبيق
          _buildSectionHeader(isArabic ? 'حول التطبيق' : 'About App'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.deepPurple),
                  title: Text(
                    isArabic ? 'إصدار التطبيق' : 'App Version',
                    style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
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