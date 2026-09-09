import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/theme/app_theme.dart';
import 'package:taamol_tech/features/auth/presentation/controllers/language_controller.dart';
import 'package:taamol_tech/features/products/presentation/pages/supabase_test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ekhegdzeowsuceorxtin.supabase.co',
    publishableKey: 'sb_publishable_3nUZ1BHOY-t1DhWwx254kw_XYcvWeKN',
  );

  runApp(const TkamolTechApp());
}

final supabase = Supabase.instance.client;

class TkamolTechApp extends StatelessWidget {
  const TkamolTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LanguageController.currentLocale,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          title: 'Tkamol Tech',
          debugShowCheckedModeBanner: false,
          locale: currentLocale,

          supportedLocales: const [Locale('ar', ''), Locale('en', '')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: AppTheme.lightTheme,
          home: const SupabaseTestScreen(),
        );
      },
    );
  }
}
