import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart'; //
import '../../../../core/constants/app_strings.dart'; //
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

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
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
                    color: Colors.black.withValues(alpha:0.2),
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