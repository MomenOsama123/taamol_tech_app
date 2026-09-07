import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LanguageFab extends StatelessWidget {
  final VoidCallback onLanguageChanged;

  const LanguageFab({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return FloatingActionButton.extended(
      onPressed: onLanguageChanged,
      tooltip: isArabic ? 'Switch to English' : 'التبديل إلى العربية',
      backgroundColor: AppColors.deepPurple,
      elevation: 4,
      icon: const Icon(
        Icons.language_rounded,
        color: AppColors.primaryCyan,
        size: 22,
      ),
      label: Text(
        isArabic ? 'English' : 'عربي',
        style: const TextStyle(
          color: AppColors.cardWhite,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
