import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../products/data/models/product_model.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product; // إذا كان null فالشاشة للإضافة، وإذا وجد فالشاشة للتعديل

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
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;
  
  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.product?.nameAr ?? '');
    _nameEnController = TextEditingController(text: widget.product?.nameEn ?? '');
    _descArController = TextEditingController(text: widget.product?.descriptionAr ?? '');
    _descEnController = TextEditingController(text: widget.product?.descriptionEn ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
    _isAvailable = widget.product?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final productData = {
      'name_ar': _nameArController.text.trim(),
      'name_en': _nameEnController.text.trim(),
      'description_ar': _descArController.text.trim(),
      'description_en': _descEnController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
      'category': _categoryController.text.trim(),
      'image_url': _imageUrlController.text.trim(),
      'is_available': _isAvailable,
    };

    try {
      if (widget.product == null) {
        // إضافة منتج جديد
        await Supabase.instance.client.from('products').insert(productData);
      } else {
        // تعديل منتج حالي
        await Supabase.instance.client
            .from('products')
            .update(productData)
            .eq('id', widget.product!.id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.product == null ? 'تمت إضافة المنتج بنجاح' : 'تم تعديل المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // إرجاع true لإعادة تحميل القائمة
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
    final bool isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'تعديل منتج' : 'إضافة منتج جديد',
          style: const TextStyle(color: AppColors.deepPurple, fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepPurple),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameArController,
                decoration: const InputDecoration(labelText: 'اسم المنتج (بالعربية)'),
                validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameEnController,
                decoration: const InputDecoration(labelText: 'اسم المنتج (بالإنجليزية)'),
                validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'السعر (ر.س)'),
                validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال السعر' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'القسم (مثل: حواسيب، طابعات)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descArController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'الوصف (بالعربية)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'رابط الصورة (Image URL)'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('المنتج متوفر في المخزون', style: TextStyle(fontFamily: 'Tajawal')),
                value: _isAvailable,
                activeColor: AppColors.deepPurple,
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
                          isEditing ? 'حفظ التعديلات' : 'إضافة المنتج',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Tajawal'),
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