
/// نموذج القسم الفرعي
class SubCategory {
  final String id;
  final String nameAr;
  final String nameEn;

  const SubCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  String getName(bool isArabic) => isArabic ? nameAr : nameEn;
}

/// نموذج القسم الرئيسي (يحتوي على الأقسام الفرعية)
class MainCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final List<SubCategory> subCategories;

  const MainCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.subCategories,
  });

  String getName(bool isArabic) => isArabic ? nameAr : nameEn;
}

/// كلاس الأقسام الموحد المحدث وفقاً للهيكلية الجديدة والتفاصيل الكاملة
class ProductCategories {
  static List<MainCategory> get all => allMainCategories;

  static const List<MainCategory> allMainCategories = [
    // 1. اجهزة كمبيوتر ولاب توبات
    MainCategory(
      id: 'computers_and_laptops',
      nameAr: 'اجهزة كمبيوتر ولاب توبات',
      nameEn: 'Computers & Laptops',
      subCategories: [
        SubCategory(
          id: 'computers_desktop',
          nameAr: 'Desktop',
          nameEn: 'Desktop',
        ),
        SubCategory(id: 'computers_laptop', nameAr: 'Laptop', nameEn: 'Laptop'),
        SubCategory(
          id: 'computers_servers',
          nameAr: 'Servers',
          nameEn: 'Servers',
        ),
        SubCategory(
          id: 'computers_workstations',
          nameAr: 'Workstations',
          nameEn: 'Workstations',
        ),
        SubCategory(id: 'computers_gaming', nameAr: 'Gaming', nameEn: 'Gaming'),
      ],
    ),

    // 2. طابعات وماكينات التصوير
    MainCategory(
      id: 'printers_and_copiers',
      nameAr: 'طابعات وماكينات التصوير',
      nameEn: 'Printers & Copiers',
      subCategories: [
        SubCategory(
          id: 'printing_printer_accessories',
          nameAr: 'إكسسوارات الطابعات',
          nameEn: 'Printer Accessories',
        ),
        SubCategory(
          id: 'printing_copier_accessories',
          nameAr: 'إكسسوارات ماكينات التصوير',
          nameEn: 'Copier Accessories',
        ),
      ],
    ),

    // 3. احبار اصلي وصيني
    MainCategory(
      id: 'ink_original_and_compatible',
      nameAr: 'احبار اصلي وصيني',
      nameEn: 'Original & Compatible Ink',
      subCategories: [
        SubCategory(
          id: 'printing_original_ink',
          nameAr: 'أحبار أصلية',
          nameEn: 'Original Ink',
        ),
        SubCategory(
          id: 'printing_compatible_ink',
          nameAr: 'أحبار صيني / Compatible',
          nameEn: 'Compatible Ink',
        ),
      ],
    ),

    // 4. قطع غيار مكنات التصوير
    MainCategory(
      id: 'copier_spare_parts',
      nameAr: 'قطع غيار مكنات التصوير',
      nameEn: 'Copier Spare Parts',
      subCategories: [
        SubCategory(
          id: 'copier_parts_all',
          nameAr: 'قطع غيار مكنات التصوير',
          nameEn: 'Copier Spare Parts',
        ),
      ],
    ),

    // 5. قطع غيار الكمبيوترولاب توبات
    MainCategory(
      id: 'computer_parts_main',
      nameAr: 'قطع غيار الكمبيوترولاب توبات',
      nameEn: 'Computer & Laptop Parts',
      subCategories: [
        SubCategory(
          id: 'computer_parts_all',
          nameAr: 'قطع غيار الكمبيوترولاب توبات',
          nameEn: 'Computer & Laptop Parts',
        ),
      ],
    ),
  ];

  /// جلب اسم القسم (رئيسي أو فرعي) باستخدام الـ ID
  static String getCategoryNameById(String id, bool isArabic) {
    if (id == 'all') return isArabic ? 'الكل' : 'All';
    for (final mainCat in allMainCategories) {
      if (mainCat.id == id) return mainCat.getName(isArabic);
      for (final subCat in mainCat.subCategories) {
        if (subCat.id == id) return subCat.getName(isArabic);
      }
    }
    return id;
  }
}
