import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/features/products/data/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  // 🟢 ضع رقم واتساب الشركة هنا بدون (00) أو (+)
  // مثال: الرقم السعودي (966500000000) أو المصري (201000000000)
  final String companyWhatsAppNumber = '+201020931722';

  const ProductDetailsScreen({super.key, required this.product});

  // دالة فتح تطبيق الواتساب مع نص تجهيز الطلب
  Future<void> _openWhatsApp(
    BuildContext context,
    bool isArabic, {
    bool isB2B = false,
  }) async {
    final String productName = product.getName(isArabic);

    // إعداد النص التلقائي الذي سيظهر للعميل في محادثة الواتساب
    final String message = isB2B
        ? (isArabic
              ? 'مرحباً تكامل تك 👋\nأرغب في الحصول على عرض سعر رسمي (B2B) للشركات للسيارة/المنتج التالي:\n- المنتج: $productName\n- رمز المنتج: #${product.id}\n- السعر الفردي: ${product.price} ر.س'
              : 'Hello Tkamol Tech 👋\nI would like to request an official B2B quote for:\n- Product: $productName\n- ID: #${product.id}\n- Price: ${product.price} SAR')
        : (isArabic
              ? 'مرحباً تكامل تك 👋\nأرغب في شراء المنتج التالي:\n- المنتج: $productName\n- رمز المنتج: #${product.id}\n- السعر: ${product.price} ر.س'
              : 'Hello Tkamol Tech 👋\nI am interested in buying:\n- Product: $productName\n- ID: #${product.id}\n- Price: ${product.price} SAR');

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
                isArabic
                    ? 'تطبيق الواتساب غير مثبت على الجهاز'
                    : 'WhatsApp is not installed on your device',
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
              isArabic
                  ? 'حدث خطأ أثناء فتح الواتساب'
                  : 'Error opening WhatsApp',
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
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 110,
                            color: Colors.grey.shade300,
                          ),
                          if (product.isB2BAvailable)
                            Positioned(
                              top: 12,
                              right: isArabic ? 12 : null,
                              left: isArabic ? null : 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isArabic
                                      ? 'متاح للشركات B2B'
                                      : 'B2B Available',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ),
                        ],
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

            // الشريط السفلي: أزرار التواصل المباشر عبر الواتساب
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // زر الشراء الفردي عبر الواتساب
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _openWhatsApp(context, isArabic, isB2B: false),
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: Text(
                        isArabic
                            ? 'طلب الشراء عبر WhatsApp'
                            : 'Order via WhatsApp',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF25D366,
                        ), // لون الواتساب الرسمي
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  // زر خاص بالشركات B2B لطلب عرض سعر رسمي
                  if (product.isB2BAvailable) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _openWhatsApp(context, isArabic, isB2B: true),
                        icon: const Icon(
                          Icons.request_quote_outlined,
                          color: AppColors.primaryGreen,
                        ),
                        label: Text(
                          isArabic
                              ? 'طلب عرض سعر للشركات (B2B)'
                              : 'Request Corporate Quote',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primaryGreen,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
