import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/gradient_header.dart';
import '../widgets/pill_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_card.dart';
import 'otp_verification.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    final email = _emailController.text.trim();

    // 1. Validate email input format
    final emailError = Validators.emailError(email);
    if (emailError != null) {
      _showMessage(emailError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Check if email exists in database
      final exists = await AuthService.instance.checkEmailExists(email);
      if (!exists) {
        _showMessage("No account found with this email address.");
        return;
      }

      // 3. Generate 4-digit OTP and send email via EmailJS
      await AuthService.instance.sendEmailOtp(email);

      if (!mounted) return;

      // 4. Navigate to OTP screen upon success
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerification(email: email),
        ),
      );
    } catch (e) {
      _showMessage("Failed to send OTP code: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GradientHeader(height: 180, logoSize: 50),
            Transform.translate(
              offset: const Offset(0, 50),
              child: AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.forgotPasswordTitle,
                      style: AppTextStyles.heading,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppStrings.forgotPasswordSubtitle,
                      style: AppTextStyles.subheading,
                    ),
                    const SizedBox(height: 30),

                    AuthTextField(
                      label: AppStrings.emailLabel,
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: PillButton(
                        text: AppStrings.sendCode,
                        backgroundColor: AppColors.primaryLight,
                        textStyle: AppTextStyles.buttonTextWhite,
                        isLoading: _isLoading,
                        onPressed: _handleSendCode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}