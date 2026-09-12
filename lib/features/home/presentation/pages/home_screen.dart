import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/constants/app_strings.dart';
import 'package:taamol_tech/core/constants/product_categories.dart';
import 'package:taamol_tech/features/auth/data/auth_service.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';
import 'package:taamol_tech/features/products/data/product_service.dart';
import 'package:taamol_tech/features/products/presentation/pages/product_details_screen.dart';
import 'package:taamol_tech/features/products/presentation/pages/add_edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ProductModel>> _productsFuture;
  bool _isAdmin = false;

  // حالة قسم الفلترة وشريط البحث
  String selectedCategory = 'all';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
    _loadAdminStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🔹 فحص صلاحية الأدمن - نفس الدالة المستخدمة في باقي التطبيق (auth_service)
  Future<void> _loadAdminStatus() async {
    final isAdmin = await isCurrentUserAdmin();
    if (mounted) setState(() => _isAdmin = isAdmin);
  }

  // 🔹 جلب المنتجات - نفس الدالة المستخدمة في لوحة تحكم الأدمن (product_service)
  Future<List<ProductModel>> _loadProducts() async {
    final products = await fetchProducts();
    return products.where((product) => product.isAvailable).toList();
  }

  Future<void> _refreshProducts() async {
    final future = _loadProducts();
    if (!mounted) return;
    setState(() {
      _productsFuture = future;
    });
    try {
      await future;
    } catch (_) {}
  }

  Future<void> _openEditor([ProductModel? product]) async {
    if (!_isAdmin) return;
   final changed = await Navigator.push<bool>(
  context,
  MaterialPageRoute(builder: (_) => AddEditProductScreen(product: product)),
);
    if (changed == true && mounted) {
      setState(() => _productsFuture = _loadProducts());
    }
  }

  Future<void> _deleteProduct(ProductModel product) async {
    if (!_isAdmin) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text(
          'هل أنت تأكد من حذف ${product.nameAr.isEmpty ? product.nameEn : product.nameAr}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await deleteProduct(product.id);
      if (mounted) setState(() => _productsFuture = _loadProducts());
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tr(context, AppStrings.appNameAr),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepPurple,
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              AppStrings.tr(context, AppStrings.sloganAr),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.deepPurple),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _openEditor(),
              backgroundColor: AppColors.deepPurple,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                isArabic ? 'إضافة منتج' : 'Add Product',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. شريط البحث
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: isArabic ? 'ابحث عن أجهزة، طابعات، أو مستلزمات...' : 'Search laptops, printers...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontFamily: 'Tajawal'),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryCyan),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. أزرار تصفية الأقسام
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('all', isArabic ? 'الكل' : 'All'),
                    for (final category in ProductCategories.all)
                      _buildCategoryChip(
                        category.key,
                        isArabic ? category.labelAr : category.labelEn,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. عرض شبكة المنتجات من Supabase
              FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.tr(context, AppStrings.productsLoadError),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _refreshProducts,
                              icon: const Icon(Icons.refresh),
                              label: Text(AppStrings.tr(context, AppStrings.retry)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final rawProducts = snapshot.data ?? [];
                  final filteredProducts = rawProducts.where((p) {
                    final matchesCategory = selectedCategory == 'all' || p.category == selectedCategory;
                    final matchesSearch = searchQuery.isEmpty ||
                        p.nameAr.toLowerCase().contains(searchQuery) ||
                        p.nameEn.toLowerCase().contains(searchQuery);
                    return matchesCategory && matchesSearch;
                  }).toList();

                  if (filteredProducts.isEmpty) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          AppStrings.tr(context, AppStrings.noProducts),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _ProductCardTile(
                        product: product,
                        isArabic: isArabic,
                        isAdmin: _isAdmin,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        onEdit: () => _openEditor(product),
                        onDelete: () => _deleteProduct(product),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryKey, String label) {
    final bool isSelected = selectedCategory == categoryKey;
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Tajawal',
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primaryCyan,
        backgroundColor: AppColors.cardWhite,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = categoryKey;
          });
        },
      ),
    );
  }
}

class _ProductCardTile extends StatelessWidget {
  final ProductModel product;
  final bool isArabic;
  final bool isAdmin;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCardTile({
    required this.product,
    required this.isArabic,
    required this.isAdmin,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: product.imageUrl.trim().isEmpty
                          ? const Icon(
                              Icons.inventory_2_outlined,
                              size: 45,
                              color: Colors.grey,
                            )
                          : CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.broken_image_outlined,
                                size: 45,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  if (isAdmin)
                    Positioned(
                      top: 4,
                      left: isArabic ? 4 : null,
                      right: isArabic ? null : 4,
                      child: PopupMenuButton<String>(
                        icon: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.more_vert, size: 16, color: AppColors.deepPurple),
                        ),
                        onSelected: (value) {
                          if (value == 'edit') onEdit();
                          if (value == 'delete') onDelete();
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('تعديل')),
                          PopupMenuItem(value: 'delete', child: Text('حذف', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.getName(isArabic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPurple,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.getDescription(isArabic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(0)} ر.س',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCyan,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: AppColors.primaryCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}