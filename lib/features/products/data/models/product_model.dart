class ProductModel {
  final String id;
  String nameAr; // 👈 غيرنا final إلى متغيّر عادي لتسهيل التعديل
  String nameEn;
  String descriptionAr;
  String descriptionEn;
  double price;
  String category;
  String imageUrl;
  bool isAvailable;
  bool isB2BAvailable;

  ProductModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.isB2BAvailable = true,
  });

  String getName(bool isArabic) => isArabic ? nameAr : nameEn;
  String getDescription(bool isArabic) => isArabic ? descriptionAr : descriptionEn;
}