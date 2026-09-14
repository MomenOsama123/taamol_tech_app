import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';
import '../../../../core/constants/app_colors.dart';

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
  late TextEditingController _categoryController;
  
  bool _isLoading = false;

  // متغيرات الصورة
  File? _selectedImage;
  String? _existingImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.product?.nameAr ?? '');
    _nameEnController = TextEditingController(text: widget.product?.nameEn ?? '');
    _descArController = TextEditingController(text: widget.product?.descriptionAr ?? '');
    _descEnController = TextEditingController(text: widget.product?.descriptionEn ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? 'laptops');
    _existingImageUrl = widget.product?.imageUrl;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // دالة اختيار الصورة من الاستوديو
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // دالة رفع الصورة إلى Supabase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      
      await Supabase.instance.client.storage
          .from('product_images') // اسم الـ Bucket
          .upload(fileName, imageFile);
          
      final imageUrl = Supabase.instance.client.storage
          .from('product_images')
          .getPublicUrl(fileName);
          
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    // التحقق من وجود صورة
    if (widget.product == null && _selectedImage == null && _existingImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة للمنتج', style: TextStyle(fontFamily: 'Tajawal')), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? finalImageUrl = _existingImageUrl;

      // رفع الصورة الجديدة إن وجدت
      if (_selectedImage != null) {
        final uploadedUrl = await _uploadImage(_selectedImage!);
        if (uploadedUrl != null) {
          finalImageUrl = uploadedUrl;
        } else {
          throw Exception('فشل رفع الصورة');
        }
      }

      // تجهيز البيانات للحفظ (متطابقة مع قاعدة البيانات)
      final productData = {
        'name_ar': _nameArController.text.trim(),
        'name_en': _nameEnController.text.trim(),
        'description_ar': _descArController.text.trim().isEmpty ? null : _descArController.text.trim(),
        'description_en': _descEnController.text.trim().isEmpty ? null : _descEnController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'category': _categoryController.text.trim(),
        'image_url': finalImageUrl,
      };

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
            content: Text(widget.product == null ? 'تمت إضافة المنتج بنجاح' : 'تم تعديل المنتج بنجاح', style: const TextStyle(fontFamily: 'Tajawal')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // العودة وتحديث القائمة
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحفظ', style: const TextStyle(fontFamily: 'Tajawal')), backgroundColor: Colors.red),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- قسم اختيار الصورة ---
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryCyan.withValues(alpha:0.5)),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(_existingImageUrl!, fit: BoxFit.cover),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.deepPurple),
                                SizedBox(height: 8),
                                Text('اضغط لاختيار صورة المنتج', style: TextStyle(fontFamily: 'Tajawal', color: AppColors.deepPurple)),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 20),
              
              // --- باقي الحقول ---
              TextFormField(
                controller: _nameArController,
                decoration: InputDecoration(labelText: 'اسم المنتج (بالعربية)', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameEnController,
                decoration: InputDecoration(labelText: 'اسم المنتج (بالإنجليزية)', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'السعر (ر.س)', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(labelText: 'القسم (مثل: laptops)', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                      validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descArController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'الوصف (بالعربية)', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descEnController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'الوصف (بالإنجليزية)', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 24),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 52,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}