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

/// الكلاس الرئيسي للأقسام الموحدة
class ProductCategories {
  static const List<MainCategory> allMainCategories = [
    // 1. أجهزة كمبيوتر
    MainCategory(
      id: 'computers',
      nameAr: 'أجهزة كمبيوتر',
      nameEn: 'Computers',
      subCategories: [
        SubCategory(id: 'computers_desktop', nameAr: 'Desktop', nameEn: 'Desktop'),
        SubCategory(id: 'computers_laptop', nameAr: 'Laptop', nameEn: 'Laptop'),
        SubCategory(id: 'computers_servers', nameAr: 'Servers', nameEn: 'Servers'),
        SubCategory(id: 'computers_workstations', nameAr: 'Workstations', nameEn: 'Workstations'),
        SubCategory(id: 'computers_gaming', nameAr: 'Gaming', nameEn: 'Gaming'),
      ],
    ),

    // 2. الطباعة وماكينات التصوير
    MainCategory(
      id: 'printing_and_copying',
      nameAr: 'الطباعة وماكينات التصوير',
      nameEn: 'Printing & Copying',
      subCategories: [
        SubCategory(id: 'printing_original_ink', nameAr: 'أحبار أصلية', nameEn: 'Original Ink'),
        SubCategory(id: 'printing_compatible_ink', nameAr: 'أحبار صيني / Compatible', nameEn: 'Compatible Ink'),
        SubCategory(id: 'printing_printer_accessories', nameAr: 'إكسسوارات الطابعات', nameEn: 'Printer Accessories'),
        SubCategory(id: 'printing_copier_accessories', nameAr: 'إكسسوارات ماكينات التصوير', nameEn: 'Copier Accessories'),
      ],
    ),

    // 3. قرطاسية وأدوات مكتبية
    MainCategory(
      id: 'stationery_and_office',
      nameAr: 'قرطاسية وأدوات مكتبية',
      nameEn: 'Stationery & Office Supplies',
      subCategories: [
        SubCategory(id: 'stationery_supplies', nameAr: 'قرطاسية وأدوات مكتبية', nameEn: 'Stationery & Office Supplies'),
      ],
    ),
  ];

  static get all => null;

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