import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/app.dart';
import 'package:taamol_tech/core/constants/navigation/app_navigator.dart';
import 'package:taamol_tech/features/auth/presentation/screens/update_password_screen.dart';

void main() async {
  // التأكد من تجهيز محرك Flutter قبل تهيئة الخدمات
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الاتصال بسيرفر Supabase
  await Supabase.initialize(
    url: 'https://ekhegdzeowsuceorxtin.supabase.co',
    publishableKey: 'sb_publishable_3nUZ1BHOY-t1DhWwx254kw_XYcvWeKN',
  );

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.passwordRecovery) {
      rootNavigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const UpdatePasswordScreen()),
      );
    }
  });

  runApp(const TkamolTechApp());
}

// كائن عام للوصول للعميل بسهولة من أي شاشة في المشروع
final supabase = Supabase.instance.client;
