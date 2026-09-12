import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';

final _supabase = Supabase.instance.client;

Future<List<ProductModel>> fetchProducts() async {
  try {
    final data = await _supabase
        .from('products')
        .select('*')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(
      data,
    ).map(ProductModel.fromMap).toList();
  } catch (error) {
    debugPrint('Error fetching products: $error');
    rethrow;
  }
}

Future<ProductModel> createProduct({
  required String nameAr,
  required String nameEn,
  required String descriptionAr,
  required String descriptionEn,
  required double price,
  required String category,
  required String imageUrl,
  bool isAvailable = true,
  bool isB2BAvailable = true,
}) async {
  final data = await _supabase
      .from('products')
      .insert({
        'name_ar': nameAr.trim(),
        'name_en': nameEn.trim(),
        'description_ar': descriptionAr.trim(),
        'description_en': descriptionEn.trim(),
        'price': price,
        'category': category,
        'image_url': imageUrl.trim(),
        'is_available': isAvailable,
        'is_b2b_available': isB2BAvailable,
      })
      .select()
      .single();

  return ProductModel.fromMap(Map<String, dynamic>.from(data));
}

Future<ProductModel> updateProduct({
  required String id,
  required String nameAr,
  required String nameEn,
  required String descriptionAr,
  required String descriptionEn,
  required double price,
  required String category,
  required String imageUrl,
  bool isAvailable = true,
  bool isB2BAvailable = true,
}) async {
  final data = await _supabase
      .from('products')
      .update({
        'name_ar': nameAr.trim(),
        'name_en': nameEn.trim(),
        'description_ar': descriptionAr.trim(),
        'description_en': descriptionEn.trim(),
        'price': price,
        'category': category,
        'image_url': imageUrl.trim(),
        'is_available': isAvailable,
        'is_b2b_available': isB2BAvailable,
      })
      .eq('id', id)
      .select()
      .single();

  return ProductModel.fromMap(Map<String, dynamic>.from(data));
}

Future<void> deleteProduct(String id) async {
  await _supabase.from('products').delete().eq('id', id);
}
