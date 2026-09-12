import 'package:flutter/material.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';
import 'package:taamol_tech/features/products/data/product_service.dart';

class SupabaseTestScreen extends StatelessWidget {
  const SupabaseTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار بيانات Supabase'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'حدث خطأ: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(
              child: Text('لا توجد منتجات حتى الآن'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.inventory_2_outlined),
                ),
                title: Text(
                  product.nameAr.isNotEmpty
                      ? product.nameAr
                      : product.nameEn,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'السعر: ${product.price} ر.س',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

