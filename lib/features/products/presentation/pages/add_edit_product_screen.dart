import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/constants/product_categories.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _descriptionArController;
  late TextEditingController _descriptionEnController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController; // 🔗 كنترولر رابط الصورة المباشر

  String? _selectedCategoryId;
  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameArController = TextEditingController(text: p?.nameAr ?? '');
    _nameEnController = TextEditingController(text: p?.nameEn ?? '');
    _descriptionArController = TextEditingController(text: p?.descriptionAr ?? '');
    _descriptionEnController = TextEditingController(text: p?.descriptionEn ?? '');
    _priceController = TextEditingController(text: p?.price != null ? p!.price.toStringAsFixed(0) : '');
    _imageUrlController = TextEditingController(text: p?.imageUrl ?? '');

    _selectedCategoryId = p?.category;
    _isAvailable = p?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار قسم المنتج'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      final productData = {
        'name_ar': _nameArController.text.trim(),
        'name_en': _nameEnController.text.trim(),
        'description_ar': _descriptionArController.text.trim(),
        'description_en': _descriptionEnController.text.trim(),
        'price': price,
        'category': _selectedCategoryId,
        'image_url': _imageUrlController.text.trim(), // حفظ الرابط النصي مباشرة في Supabase
        'is_available': _isAvailable,
      };

      if (widget.product == null) {
        await _supabase.from('products').insert(productData);
      } else {
        await _supabase.from('products').update(productData).eq('id', widget.product!.id);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 🔹 توليد عناصر القائمة المنسدلة بدون تكرار قيم أو تصادم الأقسام
  List<DropdownMenuItem<String>> _buildCategoryDropdownItems(bool isArabic) {
    final List<DropdownMenuItem<String>> items = [];

    for (final mainCat in ProductCategories.allMainCategories) {
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          value: 'header_${mainCat.id}',
          child: Text(
            '--- ${mainCat.getName(isArabic)} ---',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
              fontFamily: 'Tajawal',
              fontSize: 13,
            ),
          ),
        ),
      );

      for (final subCat in mainCat.subCategories) {
        items.add(
          DropdownMenuItem<String>(
            value: subCat.id,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '↳ ${subCat.getName(isArabic)}',
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
              ),
            ),
          ),
        );
      }
    }

    if (_selectedCategoryId != null && !items.any((item) => item.value == _selectedCategoryId)) {
      items.insert(
        0,
        DropdownMenuItem<String>(
          value: _selectedCategoryId,
          child: Text(_selectedCategoryId!),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final bool isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        title: Text(
          isEditing
              ? (isArabic ? 'تعديل المنتج' : 'Edit Product')
              : (isArabic ? 'إضافة منتج جديد' : 'Add New Product'),
          style: const TextStyle(
            color: AppColors.deepPurple,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔗 حقل إدخال رابط الصورة بدلاً من البوكس القديم
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: isArabic ? 'رابط الصورة (Image URL)' : 'Image URL',
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: const Icon(Icons.link, color: AppColors.primaryCyan),
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // 🖼️ معاينة الصورة مباشرة من الرابط المكتوب
              if (_imageUrlController.text.trim().isNotEmpty) ...[
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryCyan.withValues(alpha: 0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrlController.text.trim(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Text(
                          'رابط الصورة غير صالح أو غير متاح',
                          style: TextStyle(fontFamily: 'Tajawal', color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // اسم المنتج عربي
              TextFormField(
                controller: _nameArController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'اسم المنتج (بالعربية)' : 'Product Name (Arabic)',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال اسم المنتج' : null,
              ),
              const SizedBox(height: 12),

              // اسم المنتج انجليزي
              TextFormField(
                controller: _nameEnController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'اسم المنتج (بالإنجليزية)' : 'Product Name (English)',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  // قائمة الأقسام المنسدلة
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategoryId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'القسم' : 'Category',
                        filled: true,
                        fillColor: AppColors.cardWhite,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      hint: Text(isArabic ? 'اختر القسم' : 'Select Category', style: const TextStyle(fontSize: 12)),
                      items: _buildCategoryDropdownItems(isArabic),
                      onChanged: (val) {
                        if (val != null && !val.startsWith('header_')) {
                          setState(() => _selectedCategoryId = val);
                        }
                      },
                      validator: (val) => val == null ? 'يرجى تحديد قسم' : null,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // السعر
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'السعر (ر.س)' : 'Price (SAR)',
                        filled: true,
                        fillColor: AppColors.cardWhite,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'أدخل السعر' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // الوصف عربي
              TextFormField(
                controller: _descriptionArController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الوصف (بالعربية)' : 'Description (Arabic)',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),

              // الوصف انجليزي
              TextFormField(
                controller: _descriptionEnController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الوصف (بالإنجليزية)' : 'Description (English)',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),

              // حالة التوفر
              SwitchListTile(
                title: Text(
                  isArabic ? 'متوفر في المخزن' : 'In Stock / Available',
                  style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
                ),
                value: _isAvailable,
                activeThumbColor: AppColors.primaryCyan,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 24),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEditing
                              ? (isArabic ? 'تعديل المنتج' : 'Update Product')
                              : (isArabic ? 'إضافة المنتج' : 'Add Product'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}