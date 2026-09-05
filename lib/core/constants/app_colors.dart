import 'package:flutter/material.dart';

/// الهوية البصرية الرسمية لشركة تكامل تيك التجارية (Tkamol Tech Trading)
abstract class AppColors {
  // ---------------------------------------------------------------------------
  // 1. الألوان الأساسية للهوية (Core Palette)
  // ---------------------------------------------------------------------------

  /// Cyan (#00ADEF): لون التكنولوجيا والابتكار والأزرار النشطة
  static const Color primaryCyan = Color(0xFF00ADEF);

  /// Green (#00A651): لون النمو وحالة التوفر وشارات B2B
  static const Color primaryGreen = Color(0xFF00A651);

  /// Deep Purple / Indigo (#4B286D): لون الهيدر والـ Nav Bar والنصوص الرسمية
  static const Color deepPurple = Color(0xFF4B286D);
  static const Color primaryIndigo = Color(0xFF4B286D); // اسم مكرر لسهولة الاستدعاء

  /// Highlight Yellow (#FFFF00): لون التنبيهات والعروض وسرعة الفاعلية
  static const Color highlightYellow = Color(0xFFFFFF00);

  /// Warning Amber (#F59E0B): حالة تحذير نقص المخزون
  static const Color warningAmber = Color(0xFFF59E0B);

  // ---------------------------------------------------------------------------
  // 2. ألوان خلفيات الواجهة والبطاقات (Backgrounds & Cards)
  // ---------------------------------------------------------------------------

  /// خلفية رمادية فاتحة ناعمة جدًا للتطبيق كاملاً (#F8FAFC)
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundGray = Color(0xFFF8FAFC);

  /// خلفية البطاقات (Cards) والـ Bottom Sheets أبيض ناصع (#FFFFFF)
  static const Color cardWhite = Color(0xFFFFFFFF);

  /// لون الحد الخارجي الفاتح للبطاقات والتقسيمات (#E2E8F0)
  static const Color borderLight = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // 3. ألوان النصوص والرموز (Typography & System States)
  // ---------------------------------------------------------------------------

  static const Color textPrimary = Color(0xFF1E293B);   // نص أساسي داكن
  static const Color textSecondary = Color(0xFF64748B); // نص فرعي رمادي
  static const Color textLight = Color(0xFF94A3B8);     // نص باهت/توضيحي

  static const Color errorRed = Color(0xFFEF4444);      // حالة الخطأ أو النفاد
  static const Color successGreen = Color(0xFF00A651);  // حالة النجاح والتأكيد
}