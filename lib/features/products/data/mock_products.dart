import 'models/product_model.dart';

final List<ProductModel> mockProducts = [
  // قسم أجهزة الكمبيوتر
  ProductModel(
    id: '1',
    nameAr: 'لابتوب HP ProBook 450 G9',
    nameEn: 'HP ProBook 450 G9 Laptop',
    descriptionAr: 'معالج Intel Core i7، ذاكرة 16GB RAM، قرص 512GB SSD، شاشة 15.6 بوصة. مثالي للأعمال والشركات.',
    descriptionEn: 'Intel Core i7, 16GB RAM, 512GB SSD, 15.6" FHD Display. Perfect for corporate and business use.',
    price: 3450.0,
    category: 'laptops',
    imageUrl: 'https://via.placeholder.com/200',
  ),
  ProductModel(
    id: '2',
    nameAr: 'كمبيوتر مكتبي Dell OptiPlex Tower',
    nameEn: 'Dell OptiPlex Tower PC',
    descriptionAr: 'جهاز مكتبي متكامل للأعمال مع معالج i5 وذاكرة 8GB RAM وقرص 256GB SSD.',
    descriptionEn: 'Complete business desktop PC with i5 processor, 8GB RAM, and 256GB SSD.',
    price: 2800.0,
    category: 'laptops',
    imageUrl: 'https://via.placeholder.com/200',
  ),

  // قسم الطابعات والأحبار
  ProductModel(
    id: '3',
    nameAr: 'طابعة Canon LaserJet Pro M404dn',
    nameEn: 'Canon LaserJet Pro M404dn Printer',
    descriptionAr: 'طابعة ليزر أبيض وأسود سريعة جداً للمكاتب والشركات مع خاصية الطباعة المزدوجة.',
    descriptionEn: 'High-speed monochrome laser printer for enterprise offices with auto-duplex printing.',
    price: 1250.0,
    category: 'printers',
    imageUrl: 'https://via.placeholder.com/200',
  ),
  ProductModel(
    id: '4',
    nameAr: 'حبر HP LaserJet الأصلي 83A',
    nameEn: 'Original HP LaserJet 83A Toner',
    descriptionAr: 'خرطوشة حبر سوداء أصلية 100% تطبع حتى 1500 صفحة بجودة عالية.',
    descriptionEn: '100% Original Black Toner Cartridge, yields up to 1,500 crisp pages.',
    price: 290.0,
    category: 'printers',
    imageUrl: 'https://via.placeholder.com/200',
  ),

  // قسم الأدوات المكتبية والقرطاسية
  ProductModel(
    id: '5',
    nameAr: 'كرتون ورق تصوير A4 Double A (5 رزم)',
    nameEn: 'Double A A4 Copy Paper Box (5 Reams)',
    descriptionAr: 'ورق تصوير فاخر وزن 80 جرام، الكرتون يحتوي على 5 رزم (2500 ورقة).',
    descriptionEn: 'Premium 80gsm A4 copy paper box containing 5 reams (2,500 sheets).',
    price: 145.0,
    category: 'stationery',
    imageUrl: 'https://via.placeholder.com/200',
  ),
];