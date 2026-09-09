import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تكامل تك - الاختبار'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase.from('products').select(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطأ: ${snapshot.error}'),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات حتى الآن'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];

              return ListTile(
                title: Text(
                  (item['name_ar'] ?? item['name_en'] ?? '').toString(),
                ),
                subtitle: Text(
                  '${item['price'] ?? 0} ر.س',
                ),
              );
            },
          );
        },
      ),
    );
  }
}