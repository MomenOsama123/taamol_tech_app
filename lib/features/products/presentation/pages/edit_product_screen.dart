import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/widgets/custom_button.dart';
import 'package:taamol_tech/core/widgets/custom_text_field.dart';
import 'package:taamol_tech/features/auth/data/auth_service.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel? product; // إذا كان null فهذا يعني إضافة منتج جديد

  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _priceController;
  late TextEditingController _descArController;

  late bool _isAvailable;
  late bool _isB2BAvailable;
  late String _selectedCategory;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // تعبئة البيانات السابقة في حال كان تعديل أو ضبط قيم افتراضية للإضافة
    _nameArController = TextEditingController(
      text: widget.product?.nameAr ?? '',
    );
    _nameEnController = TextEditingController(
      text: widget.product?.nameEn ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _descArController = TextEditingController(
      text: widget.product?.descriptionAr ?? '',
    );

    _isAvailable = widget.product?.isAvailable ?? true;
    _isB2BAvailable = widget.product?.isB2BAvailable ?? true;
    _selectedCategory = widget.product?.category ?? 'laptops';
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _priceController.dispose();
    _descArController.dispose();
    super.dispose();
  }

  // دالة حفظ أو تحديث بيانات المنتج في Supabase
  Future<void> _saveProduct() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    if (!await isCurrentUserAdmin()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only admins can manage products.')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price < 0) return;

    setState(() => _isSaving = true);

    try {
      final supabase = Supabase.instance.client;

      final productData = {
        'name_ar': _nameArController.text.trim(),
        'name_en': _nameEnController.text.trim().isEmpty
            ? _nameArController.text.trim()
            : _nameEnController.text.trim(),
        'description_ar': _descArController.text.trim(),
        'description_en': _descArController.text.trim(),
        'price': price,
        'category': _selectedCategory,
        'is_available': _isAvailable,
        'is_b2b_available': _isB2BAvailable,
        'image_url':
            widget.product?.imageUrl ?? 'https://via.placeholder.com/200',
      };

      if (widget.product != null) {
        // تحديث المنتج الحالي في جدول products بناءً على id
        await supabase
            .from('products')
            .update(productData)
            .eq('id', widget.product!.id);
      } else {
        // إضافة منتج جديد لجدول products
        await supabase.from('products').insert(productData);
      }

      if (mounted) {
        Navigator.pop(context, true); // العودة وإعلام القائمة بالتحديث
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ غير متوقع: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final bool isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing
              ? (isArabic ? 'تعديل المنتج' : 'Edit Product')
              : (isArabic ? 'إضافة منتج جديد' : 'Add New Product'),
          style: const TextStyle(
            color: AppColors.deepPurple,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم المنتج بالعربي
              CustomTextField(
                controller: _nameArController,
                labelText: 'اسم المنتج (بالعربي)',
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'يرجى كتابة الاسم'
                    : null,
              ),
              const SizedBox(height: 16),

              // السعر
              CustomTextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                labelText: 'السعر (ر.س)',
                validator: (val) =>
                    val == null ||
                        double.tryParse(val.trim()) == null ||
                        double.parse(val.trim()) < 0
                    ? 'يرجى إدخال سعر صحيح'
                    : null,
              ),
              const SizedBox(height: 16),

              // اختيار القسم
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
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              // الوصف
              CustomTextField(
                controller: _descArController,
                maxLines: 3,
                labelText: 'وصف المنتج',
              ),
              const SizedBox(height: 20),

              // مفتاح حالة توفر المنتج (متاح / غير متاح)
              Card(
                color: AppColors.cardWhite,
                child: SwitchListTile(
                  title: Text(
                    isArabic ? 'توفر المنتج للبيع' : 'Product Availability',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  subtitle: Text(
                    _isAvailable
                        ? (isArabic
                              ? 'المنتج متاح حالياً للمستخدمين'
                              : 'Currently Available')
                        : (isArabic
                              ? 'المنتج غير متاح (نفذت الكمية)'
                              : 'Out of Stock'),
                    style: TextStyle(
                      color: _isAvailable ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  value: _isAvailable,
                  activeThumbColor: AppColors.primaryCyan,
                  onChanged: (val) => setState(() => _isAvailable = val),
                ),
              ),

              // مفتاح توفر المنتج للشركات (B2B)
              Card(
                color: AppColors.cardWhite,
                child: SwitchListTile(
                  title: Text(
                    isArabic
                        ? 'إتاحة لطلبات الشركات (B2B)'
                        : 'Available for B2B',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  value: _isB2BAvailable,
                  activeThumbColor: AppColors.deepPurple,
                  onChanged: (val) => setState(() => _isB2BAvailable = val),
                ),
              ),
              const SizedBox(height: 30),

              // زر الحفظ
              CustomButton(
                onPressed: _saveProduct,
                isLoading: _isSaving,
                label: isArabic ? 'حفظ التغيرات' : 'Save Changes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
