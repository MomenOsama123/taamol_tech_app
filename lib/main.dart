import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/theme/app_theme.dart';
import 'package:taamol_tech/features/auth/presentation/controllers/language_controller.dart';
import 'package:taamol_tech/features/auth/presentation/screens/login_screen.dart';
import 'package:taamol_tech/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:taamol_tech/features/products/presentation/pages/main_screen.dart';

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
          home: const AppStartScreen(),
        );
      },
    );
  }
}

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  late final Future<Widget> _initialScreen;

  @override
  void initState() {
    super.initState();
    _initialScreen = _resolveInitialScreen();
  }

  Future<Widget> _resolveInitialScreen() async {
    final session = supabase.auth.currentSession;
    if (session != null) return const MainScreen();

    final preferences = await SharedPreferences.getInstance();
    final onboardingCompleted =
        preferences.getBool('onboarding_completed') ?? false;

    return onboardingCompleted ? const LoginScreen() : const OnboardingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreen,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _StartupLoadingScreen();
        }

        if (snapshot.hasError) {
          return const LoginScreen();
        }

        return snapshot.data ?? const LoginScreen();
      },
    );
  }
}

class _StartupLoadingScreen extends StatelessWidget {
  const _StartupLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
