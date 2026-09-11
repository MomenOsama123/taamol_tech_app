import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

Future<List<Map<String, dynamic>>> fetchProducts() async {
  try {
    final data = await _supabase.from('products').select('*');
    return List<Map<String, dynamic>>.from(data);
  } catch (error) {
    debugPrint('خطأ في جلب البيانات: $error');
    return [];
  }
}
