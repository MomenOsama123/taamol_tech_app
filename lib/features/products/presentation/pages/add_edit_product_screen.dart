import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  String? _selectedCategoryId;
  bool _isAvailable = true;
  bool _isLoading = false;

  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameArController = TextEditingController(text: p?.nameAr ?? '');
    _nameEnController = TextEditingController(text: p?.nameEn ?? '');
    _descriptionArController = TextEditingController(text: p?.descriptionAr ?? '');
    _descriptionEnController = TextEditingController(text: p?.descriptionEn ?? '');
    _priceController = TextEditingController(text: p?.price != null ? p!.price.toStringAsFixed(0) : '');

    _selectedCategoryId = p?.category;
    _isAvailable = p?.isAvailable ?? true;
    _imageUrl = p?.imageUrl;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // 📸 رفع Bytes الصورة مباشرة لجلب Public URL متوافق مع الويب والموبايل
  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      setState(() => _isLoading = true);

      final bytes = await pickedFile.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final path = 'products/$fileName';

      await _supabase.storage.from('product_images').uploadBinary(path, bytes);
      final publicUrl = _supabase.storage.from('product_images').getPublicUrl(path);

      if (mounted) {
        setState(() {
          _imageUrl = publicUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل رفع الصورة: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        'image_url': _imageUrl ?? '',
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
              GestureDetector(
                onTap: _pickAndUploadImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryCyan.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: (_imageUrl != null && _imageUrl!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey),
                                SizedBox(height: 4),
                                Text('تعذر تحميل الصورة من الرابط', style: TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.deepPurple),
                            const SizedBox(height: 8),
                            Text(
                              isArabic ? 'اضغط لاختيار صورة المنتج' : 'Tap to select product image',
                              style: const TextStyle(color: AppColors.deepPurple, fontFamily: 'Tajawal'),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

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
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'القسم' : 'Category',
                        filled: true,
                        fillColor: AppColors.cardWhite,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      hint: Text(isArabic ? 'اختر القسم' : 'Select Category', style: const TextStyle(fontSize: 12)),
                      items: ProductCategories.allMainCategories.expand((mainCat) {
                        return [
                          DropdownMenuItem<String>(
                            enabled: false,
                            value: null,
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
                          ...mainCat.subCategories.map((subCat) {
                            return DropdownMenuItem<String>(
                              value: subCat.id,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '↳ ${subCat.getName(isArabic)}',
                                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                                ),
                              ),
                            );
                          }),
                        ];
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategoryId = val);
                        }
                      },
                      validator: (val) => val == null ? 'يرجى تحديد قسم' : null,
                    ),
                  ),
                  const SizedBox(width: 12),

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

              SwitchListTile(
                title: Text(
                  isArabic ? 'متوفر في المخزن' : 'In Stock / Available',
                  style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
                ),
                value: _isAvailable,
                activeColor: AppColors.primaryCyan,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 24),

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