import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taamol_tech/core/constants/app_colors.dart';
import 'package:taamol_tech/core/constants/app_strings.dart';
import 'package:taamol_tech/core/widgets/custom_button.dart';
import 'package:taamol_tech/features/auth/presentation/screens/login_screen.dart';
import 'package:taamol_tech/features/home/presentation/pages/main_screen.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final _otpController = TextEditingController();
  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otpCode = _otpController.text.trim();
    if (_isVerifying) return;

    if (otpCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.tr(context, AppStrings.otpRequired))),
      );
      return;
    }

    setState(() => _isVerifying = true);
    try {
      await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.signup,
        token: otpCode,
        email: widget.email,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.tr(context, AppStrings.otpVerified))),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } on AuthException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.tr(context, AppStrings.otpVerificationError),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendEmail() async {
    if (_isResending) return;
    setState(() => _isResending = true);
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.tr(context, AppStrings.resendSuccess)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on AuthException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.tr(context, AppStrings.resendError)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: AppColors.deepPurple,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.tr(context, AppStrings.confirmEmailTitle),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepPurple,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.tr(context, AppStrings.confirmEmailSentTo),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepPurple,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.tr(context, AppStrings.confirmEmailInstructions),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 36),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: AppStrings.tr(context, AppStrings.otpCode),
                  counterText: '',
                ),
                onSubmitted: (_) => _verifyOtp(),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _isVerifying ? null : _verifyOtp,
                isLoading: _isVerifying,
                label: AppStrings.tr(context, AppStrings.verifyOtp),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                label: AppStrings.tr(context, AppStrings.backToLogin),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isResending ? null : _resendEmail,
                child: _isResending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        AppStrings.tr(context, AppStrings.resendEmail),
                        style: const TextStyle(
                          color: AppColors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
