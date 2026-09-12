/// قائمة موحّدة للأقسام المتاحة للمنتجات.
/// تُستخدم في شاشة إضافة/تعديل المنتج (Dropdown) وفي فلتر الشاشة الرئيسية،
/// عشان القيمة اللي بيختارها الأدمن تطابق دايمًا أزرار الفلترة عند العميل.
class ProductCategory {
  final String key;
  final String labelAr;
  final String labelEn;

  const ProductCategory({
    required this.key,
    required this.labelAr,
    required this.labelEn,
  });
}

abstract class ProductCategories {
  static const List<ProductCategory> all = [
    ProductCategory(key: 'laptops', labelAr: 'حواسب ولابتوبات', labelEn: 'Laptops'),
    ProductCategory(key: 'printers', labelAr: 'طابعات وأحبار', labelEn: 'Printers'),
    ProductCategory(key: 'stationery', labelAr: 'قرطاسية ومكتبية', labelEn: 'Stationery'),
  ];

  /// يرجّع الاسم المعروض لأي مفتاح قسم، حتى لو كان قسم قديم مش موجود
  /// حاليًا في القائمة (بيرجع المفتاح نفسه كنص احتياطي).
  static String labelFor(String key, bool isArabic) {
    for (final category in all) {
      if (category.key == key) {
        return isArabic ? category.labelAr : category.labelEn;
      }
    }
    return key;
  }
}
