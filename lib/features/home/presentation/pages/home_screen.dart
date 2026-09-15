import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/constants/app_strings.dart';
import 'package:taamol_tech/core/constants/product_categories.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';
import 'package:taamol_tech/features/products/presentation/pages/add_edit_product_screen.dart';
import 'package:taamol_tech/features/products/presentation/pages/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ProductModel>> _productsFuture;
  final _supabase = Supabase.instance.client;
  bool _isAdmin = false;

  // 🌟 متغيرات الفلترة الشجرية
  String selectedMainCategory = 'all'; // 'all', 'computers_and_laptops', 'printers_and_copiers'
  String selectedCategory = 'all';     // ID القسم الفرعي المختار

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

  Future<void> _loadAdminStatus() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isAdmin = false);
        return;
      }

      final response = await _supabase
          .from('profiles')
          .select('is_admin')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null && mounted) {
        final dynamic rawIsAdmin = response['is_admin'];
        final bool isAdmin = rawIsAdmin == true ||
            rawIsAdmin.toString().toLowerCase() == 'true' ||
            rawIsAdmin == 1;

        setState(() {
          _isAdmin = isAdmin;
        });
      }
    } catch (e) {
      debugPrint('Error loading admin status: $e');
    }
  }

  Future<List<ProductModel>> _loadProducts() async {
    try {
      final response = await _supabase.from('products').select('*');
      final List<dynamic> dataList = response as List<dynamic>;

      return dataList.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return ProductModel.fromMap(map);
      }).toList();
    } catch (error, stackTrace) {
      debugPrint('Supabase Fetch Error: $error');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
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
        title: const Text(
          'حذف المنتج',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: Text(
          'هل أنت متأكد من حذف ${product.nameAr.isEmpty ? product.nameEn : product.nameAr}؟',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _supabase.from('products').delete().eq('id', product.id);
      if (mounted) {
        setState(() => _productsFuture = _loadProducts());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on PostgrestException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.red),
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
                  hintText: isArabic
                      ? 'ابحث عن أجهزة، طابعات، أو قطع غيار...'
                      : 'Search laptops, printers, spare parts...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontFamily: 'Tajawal',
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primaryCyan,
                  ),
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

              // 2. شريط التصنيفات الشجري (الرئيسية والفرعية)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // أ. الأقسام الرئيسية
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMainCategoryChip(
                          'all',
                          isArabic ? 'الكل' : 'All',
                        ),
                        ...ProductCategories.allMainCategories.map((mainCat) {
                          return _buildMainCategoryChip(
                            mainCat.id,
                            mainCat.getName(isArabic),
                          );
                        }),
                      ],
                    ),
                  ),

                  // ب. الأقسام الفرعية (تظهر فقط عند اختيار قسم رئيسي غير "الكل")
                  if (selectedMainCategory != 'all') ...[
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSubCategoryChip(
                            selectedMainCategory,
                            isArabic ? 'كل أنواع القسم' : 'All Types',
                          ),
                          ...ProductCategories.allMainCategories
                              .firstWhere((m) => m.id == selectedMainCategory)
                              .subCategories
                              .map((subCat) {
                            return _buildSubCategoryChip(
                              subCat.id,
                              subCat.getName(isArabic),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),

              // 3. شبكة عرض المنتجات
              FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryCyan,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.tr(
                                context,
                                AppStrings.productsLoadError,
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _refreshProducts,
                              icon: const Icon(Icons.refresh),
                              label: Text(
                                AppStrings.tr(context, AppStrings.retry),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final rawProducts = snapshot.data ?? [];

                  final filteredProducts = rawProducts.where((p) {
                    if (!_isAdmin && p.isAvailable == false) return false;

                    // منطق المطابقة بالأقسام الشجرية
                    bool matchesCategory = false;
                    if (selectedCategory == 'all') {
                      matchesCategory = true;
                    } else if (selectedCategory == selectedMainCategory) {
                      final mainCatMatches = ProductCategories.allMainCategories
                          .where((m) => m.id == selectedMainCategory);

                      if (mainCatMatches.isNotEmpty) {
                        matchesCategory = mainCatMatches.first.subCategories
                            .any((sub) => sub.id == p.category);
                      }
                    } else {
                      matchesCategory = p.category == selectedCategory;
                    }

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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
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
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
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

  Widget _buildMainCategoryChip(String id, String label) {
    final bool isSelected = selectedMainCategory == id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Tajawal',
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.deepPurple,
        backgroundColor: AppColors.cardWhite,
        showCheckmark: false,
        onSelected: (selected) {
          setState(() {
            selectedMainCategory = id;
            selectedCategory = id;
          });
        },
      ),
    );
  }

  Widget _buildSubCategoryChip(String id, String label) {
    final bool isSelected = selectedCategory == id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(
          id == selectedMainCategory ? label : '↳ $label',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryCyan,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            fontFamily: 'Tajawal',
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primaryCyan,
        backgroundColor: AppColors.primaryCyan.withValues(alpha: .1),
        showCheckmark: false,
        onSelected: (selected) {
          setState(() {
            selectedCategory = id;
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
              color: Colors.black.withValues(alpha: .05),
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.broken_image_outlined,
                                size: 45,
                                color: Colors.grey,
                              ),
                            )
                          : const Icon(
                              Icons.inventory_2_outlined,
                              size: 45,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  if (isAdmin && !product.isAvailable)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'غير متوفر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
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
                          child: Icon(
                            Icons.more_vert,
                            size: 16,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'edit') onEdit();
                          if (value == 'delete') onDelete();
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(
                              'تعديل',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'حذف',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.getName(isArabic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPurple,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ProductCategories.getCategoryNameById(
                      product.category,
                      isArabic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryCyan,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(0)} ر.س',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCyan,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.primaryCyan,
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