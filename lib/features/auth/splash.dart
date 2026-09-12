import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart'; //
import '../../../../core/constants/app_strings.dart'; //
import '../home/presentation/pages/main_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // تأخير بسيط لعرض الشعار فقط، مش عشان ننتظر أي بيانات
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // 1. فيه جلسة مستخدم محفوظة (Session) بالفعل؟ يبقى يدخل على طول للتطبيق،
    //    وهناك هيتحدد الـ role (أدمن / مستخدم عادي) من auth_service.
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _goTo(const MainScreen());
      return;
    }

    // 2. مفيش جلسة، هل سبق وشاف المستخدم شاشات الـ onboarding؟
    final preferences = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding =
        preferences.getBool('onboarding_completed') ?? false;

    if (!mounted) return;

    if (hasSeenOnboarding) {
      _goTo(const LoginScreen());
    } else {
      _goTo(const OnboardingScreen());
    }
  }

  void _goTo(Widget screen) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepPurple, //[cite: 1]
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الشعار
            Container(
              width: 110,
              height: 110,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite, //[cite: 1]
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(
                Icons.devices_other_rounded,
                size: 60,
                color: AppColors.primaryCyan, //[cite: 1]
              ),
            ),
            const SizedBox(height: 24),

            // اسم الشركة بالعربي
            const Text(
              "تكامل تيك التجارية",
              style: TextStyle(
                color: AppColors.cardWhite, //[cite: 1]
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 4),

            // اسم الشركة بالإنجليزي
            const Text(
              "Tkamol Tech Trading",
              style: TextStyle(
                color: AppColors.primaryCyan, //[cite: 1]
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 12),

            // السلوجان المترجم
            Text(
              AppStrings.tr(context, AppStrings.sloganAr),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.borderLight, //[cite: 1]
                fontSize: 12,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
