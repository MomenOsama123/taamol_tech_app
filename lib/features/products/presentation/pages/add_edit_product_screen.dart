import 'package:flutter/material.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/constants/product_categories.dart';
import 'package:taamol_tech/features/auth/data/auth_service.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';
import 'package:taamol_tech/features/products/data/product_service.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _descArController;
  late TextEditingController _descEnController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  late String _selectedCategory;
  bool _isAvailable = true;
  bool _isLoading = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    _nameArController = TextEditingController(text: p?.nameAr ?? '');
    _nameEnController = TextEditingController(text: p?.nameEn ?? '');
    _descArController = TextEditingController(text: p?.descriptionAr ?? '');
    _descEnController = TextEditingController(text: p?.descriptionEn ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.price.toString() : '',
    );
    _imageUrlController = TextEditingController(text: p?.imageUrl ?? '');
    _isAvailable = p?.isAvailable ?? true;

    // لو القسم المحفوظ مع المنتج مش موجود في القائمة الحالية (قسم قديم مثلاً)،
    // منختار أول قسم افتراضي بدل ما نسيب قيمة مش موجودة في الـ Dropdown.
    final savedCategory = p?.category;
    final isKnownCategory =
        savedCategory != null && ProductCategories.all.any((c) => c.key == savedCategory);
    _selectedCategory = isKnownCategory ? savedCategory : ProductCategories.all.first.key;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // التحقق من صلاحيات الأدمن
    final isAdmin = await isCurrentUserAdmin();
    if (!isAdmin) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('عذراً، الأدمن فقط يمكنه إدارة المنتجات.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final nameAr = _nameArController.text.trim();
    final nameEn = _nameEnController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    try {
      if (_isEditing) {
        // تعديل منتج
        await updateProduct(
          id: widget.product!.id,
          nameAr: nameAr,
          nameEn: nameEn.isEmpty ? nameAr : nameEn,
          descriptionAr: _descArController.text.trim(),
          descriptionEn: _descEnController.text.trim(),
          price: price,
          category: _selectedCategory,
          imageUrl: _imageUrlController.text.trim(),
          isAvailable: _isAvailable,
        );
      } else {
        // إضافة منتج جديد
        await createProduct(
          nameAr: nameAr,
          nameEn: nameEn.isEmpty ? nameAr : nameEn,
          descriptionAr: _descArController.text.trim(),
          descriptionEn: _descEnController.text.trim(),
          price: price,
          category: _selectedCategory,
          imageUrl: _imageUrlController.text.trim(),
          isAvailable: _isAvailable,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'تم تعديل المنتج بنجاح' : 'تمت إضافة المنتج بنجاح',
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء حفظ المنتج: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'تعديل منتج' : 'إضافة منتج جديد'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameArController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المنتج (بالعربي) *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال اسم المنتج بالعربي';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameEnController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المنتج (بالإنجليزي)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'السعر *',
                        border: OutlineInputBorder(),
                        suffixText: 'ر.س',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال السعر';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'يرجى إدخال رقم صحيح للسعر';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'الفئة (Category)',
                        border: OutlineInputBorder(),
                      ),
                      items: ProductCategories.all
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.key,
                              child: Text(c.labelAr),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCategory = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'رابط الصورة (URL)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descArController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'الوصف (بالعربي)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descEnController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'الوصف (بالإنجليزي)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('المناحة في المخزون (متاح للبيع)'),
                      value: _isAvailable,
                      onChanged: (val) => setState(() => _isAvailable = val),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primaryCyan,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _saveProduct,
                      child: Text(
                        _isEditing ? 'تحديث البيانات' : 'حفظ المنتج',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
