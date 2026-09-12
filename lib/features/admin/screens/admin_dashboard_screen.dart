import 'package:flutter/material.dart';
import 'package:taamol_tech/features/auth/data/auth_service.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';
import 'package:taamol_tech/features/products/data/product_service.dart';
import 'package:taamol_tech/features/products/presentation/pages/edit_product_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  String? _error;

  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      debugPrint('ADMIN: checking admin status...');

      final isAdmin = await isCurrentUserAdmin();

      debugPrint('ADMIN: isAdmin = $isAdmin');

      if (!isAdmin) {
        if (!mounted) return;

        setState(() {
          _isAdmin = false;
          _isLoading = false;
        });

        return;
      }

      debugPrint('ADMIN: fetching products...');

      final products = await fetchProducts();

      debugPrint('ADMIN: products loaded = ${products.length}');

      if (!mounted) return;

      setState(() {
        _isAdmin = true;
        _products = products;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('ADMIN ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProducts() async {
    try {
      final products = await fetchProducts();

      if (!mounted) return;

      setState(() {
        _products = products;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _addProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProductScreen()),
    );

    if (!mounted) return;

    await _refreshProducts();
  }

  Future<void> _editProduct(ProductModel product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
    );

    if (!mounted) return;

    await _refreshProducts();
  }

  Future<void> _deleteProduct(ProductModel product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف المنتج'),
          content: Text('هل أنت متأكد من حذف "${product.nameAr}"؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await deleteProduct(product.id);

      if (!mounted) return;

      setState(() {
        _products.removeWhere((item) => item.id == product.id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حذف المنتج بنجاح')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل حذف المنتج: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'غير مسموح لك بالدخول إلى لوحة التحكم.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: _refreshProducts,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        icon: const Icon(Icons.add),
        label: const Text('إضافة منتج'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null && _products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('حدث خطأ أثناء تحميل المنتجات', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _initialize,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshProducts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Center(child: Text('لا توجد منتجات حتى الآن')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final product = _products[index];

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: _buildProductImage(product),
              title: Text(
                product.nameAr.isNotEmpty ? product.nameAr : product.nameEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${product.price} ر.س'),
                    const SizedBox(height: 4),
                    Text(product.isAvailable ? 'متاح' : 'غير متاح'),
                  ],
                ),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _editProduct(product);
                  } else if (value == 'delete') {
                    _deleteProduct(product);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text('تعديل'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 8),
                        Text('حذف'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    if (product.imageUrl.trim().isEmpty) {
      return const CircleAvatar(child: Icon(Icons.inventory_2_outlined));
    }

    return CircleAvatar(
      radius: 28,
      backgroundImage: NetworkImage(product.imageUrl),
    );
  }
}
