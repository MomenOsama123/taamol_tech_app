import 'package:flutter/material.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // 🟢 رقم واتساب شركة تكامل تك المخصص للتواصل الدائم
  final String companyWhatsAppNumber = '201020931722'; // ضع الرقم بدون (+) أو (00)

  // دالة فتح الواتساب مباشرة لمحادثات الدعم والاستفسارات
  Future<void> _openWhatsApp(BuildContext context, bool isArabic) async {
    final String message = isArabic
        ? 'مرحباً فريق تكامل تك 👋\nأود الاستفسار عن الخدمات والمنتجات المتاحة.'
        : 'Hello Tkamol Tech Team 👋\nI would like to inquire about your products & services.';

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
                isArabic ? 'تطبيق الواتساب غير مثبت على جهازك' : 'WhatsApp is not installed on your device',
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
              isArabic ? 'حدث خطأ أثناء الاتصال بالواتساب' : 'Error opening WhatsApp',
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
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        title: Text(
          isArabic ? 'تواصل معنا' : 'Contact Us',
          style: const TextStyle(
            color: AppColors.deepPurple,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. كارت الدعم الفني والمبيعات عبر الواتساب (البانر الرئيسي)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.deepPurple, AppColors.primaryCyan],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCyan.withAlpha(77),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.support_agent, size: 44, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isArabic ? 'خدمة العملاء والمبيعات' : 'Customer Service & Sales',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isArabic
                        ? 'فريقنا متواجد للرد على جميع استفساراتك وطلبات B2B عبر الواتساب'
                        : 'Our team is available for inquiries & B2B orders via WhatsApp',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🟢 زر التحويل المباشر للواتساب
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _openWhatsApp(context, isArabic),
                      icon: const Icon(Icons.chat, color: Colors.white, size: 24),
                      label: Text(
                        isArabic ? 'محادثة عبر WhatsApp الآن' : 'Chat via WhatsApp Now',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366), // اللون الرسمي للواتساب
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 2. كروت المعلومات المباشرة (رقم الهاتف، الساعات، العنوان)
            _buildContactInfoCard(
              context,
              icon: Icons.phone_android,
              iconColor: AppColors.primaryCyan,
              title: isArabic ? 'رقم الواتساب / المبيعات' : 'WhatsApp / Sales Number',
              subtitle: '+$companyWhatsAppNumber',
              onTap: () => _openWhatsApp(context, isArabic),
            ),
            const SizedBox(height: 12),

            _buildContactInfoCard(
              context,
              icon: Icons.access_time,
              iconColor: AppColors.deepPurple,
              title: isArabic ? 'ساعات العمل' : 'Working Hours',
              subtitle: isArabic ? 'الأحد - الخميس: 8:00 ص - 6:00 م' : 'Sun - Thu: 8:00 AM - 6:00 PM',
            ),
            const SizedBox(height: 12),

            _buildContactInfoCard(
              context,
              icon: Icons.business,
              iconColor: AppColors.primaryGreen,
              title: isArabic ? 'طلبات وعروض أسعار B2B' : 'B2B & Corporate Requests',
              subtitle: isArabic ? 'متاحة للشركات والمؤسسات مع الفواتير الضريبية' : 'Available for corporate & tax invoices',
            ),
          ],
        ),
      ),
    );
  }

  // ودجت بناء بطاقات المعلومات
  Widget _buildContactInfoCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: iconColor.withAlpha(77),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.deepPurple,
            fontFamily: 'Tajawal',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontFamily: 'Tajawal',
          ),
        ),
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
            : null,
        onTap: onTap,
      ),
    );
  }
}