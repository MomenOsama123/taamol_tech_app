import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  // 🟢 ضع رقم واتساب الشركة هنا بدون (00) أو (+)
  final String companyWhatsAppNumber = '966500000000';

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  // دالة فتح تطبيق الواتساب مع رسالة الطلب
  Future<void> _openWhatsApp(BuildContext context, bool isArabic) async {
    final String productName = product.getName(isArabic);
    
    // نص الرسالة التلقائي للعميل
    final String message = isArabic
        ? 'مرحباً تكامل تك 👋\nأرغب في شراء المنتج التالي:\n- المنتج: $productName\n- رمز المنتج: #${product.id}\n- السعر: ${product.price} ر.س'
        : 'Hello Tkamol Tech 👋\nI am interested in buying:\n- Product: $productName\n- ID: #${product.id}\n- Price: ${product.price} SAR';

    final Uri whatsappUrl = Uri.parse(
      'https://wa.me/$companyWhatsAppNumber?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isArabic ? 'تطبيق الواتساب غير مثبت على الجهاز' : 'WhatsApp is not installed on your device',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic ? 'حدث خطأ أثناء فتح الواتساب' : 'Error opening WhatsApp',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة المنتج
                    Container(
                      height: 230,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 110,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // اسم المنتج والسعر
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.getName(isArabic),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepPurple,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${product.price} ر.س',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryCyan,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // وصف المنتج
                    Text(
                      isArabic ? 'تفاصيل المنتج' : 'Product Details',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepPurple,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.getDescription(isArabic),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // زر التواصل المباشر الوحيد عبر الواتساب
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _openWhatsApp(context, isArabic),
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: Text(
                    isArabic ? 'طلب الشراء عبر WhatsApp' : 'Order via WhatsApp',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // لون الواتساب
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ```[cite: 1]

// ---

// ### 2️⃣ التعديل في `profile_screen.dart`
// * تم إزالة **"إدارة طلبات العملاء"** أو أي ذكر لعروض أسعار الشركات B2B.
// * الأدمن فقط سيحتاج خياري:
//   1. **إضافة منتج جديد** (`add_product_screen.dart`).
//   2. **إدارة وتعديل المنتجات** (`edit_product_screen.dart`).

// ---

// ### 3️⃣ الملفات المطلوبة الآن للتطبيق البسيط:

// 1. **`lib/features/products/presentation/pages/home_screen.dart`**:
//    * عرض كتالوج المنتجات مع زر تصفية وميزة البحث.
//    * إظهار زر الإضافة FloatingActionButton للأدمن فقط لتنشيط إضافة المنتجات.
// 2. **`lib/features/products/presentation/pages/product_details_screen.dart`**:
//    * عرض بيانات المنتج وزر الشراء المباشر عبر **WhatsApp**.
// 3. **`lib/features/admin/presentation/screens/add_edit_product_screen.dart`**:
//    * شاشة واحدة مخصصة للأدمن لإدخال اسم المنتج، السعر، القسم، والصورة، إما للإضافة أو التعديل.

// هل ترغب في أن نكتب كود شاشة **إضافة/تعديل المنتجات المخصصة للأدمن (`add_edit_product_screen.dart`)** الآن؟