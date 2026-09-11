import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/features/auth/presentation/widgets/language_selector_widget.dart';

void main() async {
  // التأكد من تجهيز محرك Flutter قبل تهيئة الخدمات
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الاتصال بسيرفر Supabase
  await Supabase.initialize(
    url: 'https://ekhegdzeowsuceorxtin.supabase.co',
    publishableKey: 'sb_publishable_3nUZ1BHOY-t1DhWwx254kw_XYcvWeKN',
  );

  runApp(const TkamolTechApp());
}

// كائن عام للوصول للعميل بسهولة من أي شاشة في المشروع
final supabase = Supabase.instance.client;
