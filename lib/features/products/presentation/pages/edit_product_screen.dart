import 'package:flutter/material.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/widgets/custom_button.dart';
import 'package:taamol_tech/core/widgets/custom_text_field.dart';
import 'package:taamol_tech/features/auth/data/auth_service.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';
import 'package:taamol_tech/features/products/data/product_service.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const EditProductScreen({
    super.key,
    this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _priceController;
  late final TextEditingController _descArController;
  late final TextEditingController _descEnController;
  late final TextEditingController _imageUrlController;

  late bool _isAvailable;
  late bool _isB2BAvailable;
  late String _selectedCategory;

  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _nameArController = TextEditingController(
      text: product?.nameAr ?? '',
    );

    _nameEnController = TextEditingController(
      text: product?.nameEn ?? '',
    );

    _priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );

    _descArController = TextEditingController(
      text: product?.descriptionAr ?? '',
    );

    _descEnController = TextEditingController(
      text: product?.descriptionEn ?? '',
    );

    _imageUrlController = TextEditingController(
      text: product?.imageUrl ?? '',
    );

    _isAvailable = product?.isAvailable ?? true;
    _isB2BAvailable = product?.isB2BAvailable ?? true;
    _selectedCategory = product?.category ?? 'laptops';
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _priceController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final isAdmin = await isCurrentUserAdmin();

    if (!isAdmin) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only admins can manage products.'),
        ),
      );

      return;
    }

    final price = double.tryParse(
      _priceController.text.trim(),
    );

    if (price == null || price < 0) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isEditing) {
        await updateProduct(
          id: widget.product!.id,
          nameAr: _nameArController.text.trim(),
          nameEn: _nameEnController.text.trim().isEmpty
              ? _nameArController.text.trim()
              : _nameEnController.text.trim(),
          descriptionAr: _descArController.text.trim(),
          descriptionEn: _descEnController.text.trim(),
          price: price,
          category: _selectedCategory,
          imageUrl: _imageUrlController.text.trim(),
          isAvailable: _isAvailable,
          isB2BAvailable: _isB2BAvailable,
        );
      } else {
        await createProduct(
          nameAr: _nameArController.text.trim(),
          nameEn: _nameEnController.text.trim().isEmpty
              ? _nameArController.text.trim()
              : _nameEnController.text.trim(),
          descriptionAr: _descArController.text.trim(),
          descriptionEn: _descEnController.text.trim(),
          price: price,
          category: _selectedCategory,
          imageUrl: _imageUrlController.text.trim(),
          isAvailable: _isAvailable,
          isB2BAvailable: _isB2BAvailable,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'تم تحديث المنتج بنجاح'
                : 'تم إضافة المنتج بنجاح',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء حفظ المنتج:\n$error',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isEditing
              ? (isArabic ? 'تعديل المنتج' : 'Edit Product')
              : (isArabic
                  ? 'إضافة منتج جديد'
                  : 'Add New Product'),
          style: const TextStyle(
            color: AppColors.deepPurple,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.deepPurple,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameArController,
                labelText: 'اسم المنتج (بالعربي)',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى كتابة اسم المنتج';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _nameEnController,
                labelText: 'Product Name (English)',
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                labelText: 'السعر',
                validator: (value) {
                  final price = double.tryParse(
                    value?.trim() ?? '',
                  );

                  if (price == null || price < 0) {
                    return 'يرجى إدخال سعر صحيح';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'القسم',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'laptops',
                    child: Text('حواسب ولابتوبات'),
                  ),
                  DropdownMenuItem(
                    value: 'printers',
                    child: Text('طابعات وأحبار'),
                  ),
                  DropdownMenuItem(
                    value: 'stationery',
                    child: Text('قرطاسية ومكتبية'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _descArController,
                maxLines: 4,
                labelText: 'وصف المنتج بالعربي',
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _descEnController,
                maxLines: 4,
                labelText: 'Product Description (English)',
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                labelText: 'رابط صورة المنتج',
              ),

              const SizedBox(height: 20),

              Card(
                color: AppColors.cardWhite,
                child: SwitchListTile(
                  title: const Text(
                    'توفر المنتج للبيع',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  subtitle: Text(
                    _isAvailable
                        ? 'المنتج متاح حالياً'
                        : 'المنتج غير متاح',
                  ),
                  value: _isAvailable,
                  activeThumbColor: AppColors.primaryCyan,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
              ),

              Card(
                color: AppColors.cardWhite,
                child: SwitchListTile(
                  title: const Text(
                    'إتاحة لطلبات الشركات (B2B)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  value: _isB2BAvailable,
                  activeThumbColor: AppColors.deepPurple,
                  onChanged: (value) {
                    setState(() {
                      _isB2BAvailable = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(
                onPressed: _saveProduct,
                isLoading: _isSaving,
                label: _isEditing
                    ? (isArabic
                        ? 'حفظ التغييرات'
                        : 'Save Changes')
                    : (isArabic
                        ? 'إضافة المنتج'
                        : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
