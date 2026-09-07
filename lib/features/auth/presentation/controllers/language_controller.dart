import 'package:flutter/material.dart';

class LanguageController {
  static final ValueNotifier<Locale> currentLocale = ValueNotifier(const Locale('ar'));

  static void changeLanguage(String languageCode) {
    if (languageCode != 'ar' && languageCode != 'en') {
      return;
    }

    currentLocale.value = Locale(languageCode);
  }

  static void toggleLanguage() {
    changeLanguage(currentLocale.value.languageCode == 'ar' ? 'en' : 'ar');
  }
}