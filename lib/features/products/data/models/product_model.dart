class ProductModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final bool isB2BAvailable;

  const ProductModel({
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

  factory ProductModel.fromMap(Map<String, dynamic> item) {
    final rawPrice = item['price'];

    return ProductModel(
      id: item['id']?.toString() ?? '',
      nameAr: item['name_ar']?.toString() ?? '',
      nameEn: item['name_en']?.toString() ?? '',
      descriptionAr: item['description_ar']?.toString() ?? '',
      descriptionEn: item['description_en']?.toString() ?? '',
      price: rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice?.toString() ?? '') ?? 0,
      category: item['category']?.toString() ?? 'general',
      imageUrl: item['image_url']?.toString() ?? '',
      isAvailable: item['is_available'] as bool? ?? true,
      isB2BAvailable: item['is_b2b_available'] as bool? ?? true,
    );
  }

  String getName(bool isArabic) => isArabic ? nameAr : nameEn;
  String getDescription(bool isArabic) =>
      isArabic ? descriptionAr : descriptionEn;
}
