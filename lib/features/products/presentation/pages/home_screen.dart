import 'package:flutter/material.dart';

// Package Imports
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/constants/app_strings.dart';
import 'package:taamol_tech/features/products/data/mock_products.dart';
import 'package:taamol_tech/features/products/presentation/widgets/product_card.dart';
import 'package:taamol_tech/features/products/presentation/pages/product_details_screen.dart';
import 'package:taamol_tech/features/products/presentation/pages/edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool
  isAdmin; // 👈 تحديد هل المستخدم آدمن أم لا (يمكن تغييرها إلى true للتجربة)

  const HomeScreen({
    super.key,
    this.isAdmin = true, // جعلناها true افتراضياً لتجربة ميزات الآدمن
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final normalizedQuery = _searchQuery.trim().toLowerCase();
    final displayedProducts = mockProducts
        .where((product) {
          final matchesCategory =
              selectedCategory == 'all' || product.category == selectedCategory;
          final matchesSearch =
              normalizedQuery.isEmpty ||
              product.nameAr.toLowerCase().contains(normalizedQuery) ||
              product.nameEn.toLowerCase().contains(normalizedQuery) ||
              product.descriptionAr.toLowerCase().contains(normalizedQuery) ||
              product.descriptionEn.toLowerCase().contains(normalizedQuery);
          return matchesCategory && matchesSearch;
        })
        .toList(growable: false);

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
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.deepPurple,
            ),
            onPressed: () {},
          ),
        ],
      ),

      // 🟢 1. إظهار زر الـ FAB للآدمن فقط لإضافة منتج جديد
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const EditProductScreen(), // فتح شاشة الإضافة
                  ),
                );
                if (result == true) {
                  setState(() {}); // إعادة تحديث الشاشة بعد الحفظ
                }
              },
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط البحث
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: isArabic
                    ? 'ابحث عن أجهزة، طابعات، أو مستلزمات...'
                    : 'Search laptops, printers...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontFamily: 'Tajawal',
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryCyan,
                ),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: isArabic ? 'مسح البحث' : 'Clear search',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
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

            // بانر العروض الخاصة بالشركات (B2B Banner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepPurple, AppColors.primaryCyan],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic
                              ? 'عروض وتجهيزات الشركات (B2B)'
                              : 'Corporate Quotations & Setup',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isArabic
                              ? 'احصل على أسعار جملة وفواتير ضريبية فورية'
                              : 'Get wholesale pricing & instant tax quotes',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.business_center,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // أزرار الأقسام
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('all', isArabic ? 'الكل' : 'All'),
                  _buildCategoryChip(
                    'laptops',
                    isArabic ? 'حواسب ولابتوبات' : 'Laptops',
                  ),
                  _buildCategoryChip(
                    'printers',
                    isArabic ? 'طابعات وأحبار' : 'Printers',
                  ),
                  _buildCategoryChip(
                    'stationery',
                    isArabic ? 'قرطاسية ومكتبية' : 'Stationery',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // شبكة المنتجات
            if (displayedProducts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    isArabic ? 'لا توجد منتجات مطابقة' : 'No matching products',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  return Stack(
                    children: [
                      ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      ),
                      if (widget.isAdmin)
                        Positioned(
                          top: 6,
                          left: isArabic ? 6 : null,
                          right: isArabic ? null : 6,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.deepPurple,
                            child: IconButton(
                              tooltip: isArabic
                                  ? 'تعديل المنتج'
                                  : 'Edit product',
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditProductScreen(product: product),
                                  ),
                                );
                                if (result == true && mounted) setState(() {});
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryKey, String label) {
    final bool isSelected = selectedCategory == categoryKey;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
