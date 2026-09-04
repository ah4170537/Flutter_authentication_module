import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';
import '../services/auth_service.dart';
import '../widgets/gradient_header.dart';
import '../widgets/pill_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_card.dart';
import 'login.dart';

class NewPassword extends StatefulWidget {
  final String email;

  const NewPassword({super.key, required this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      setState(() => _errorText = "Please fill in both fields");
      return;
    }
    if (password.length < 6) {
      setState(() => _errorText = "Password must be at least 6 characters");
      return;
    }
    if (password != confirm) {
      setState(() => _errorText = "Passwords do not match");
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    try {
      await AuthService.instance.resetPasswordForEmail(
        email: widget.email,
        newPassword: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password updated for ${widget.email}! Please login."),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    } catch (e) {
      setState(() => _errorText = e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                      AppStrings.newPasswordTitle,
                      style: AppTextStyles.heading,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Set a new password for ${widget.email}",
                      style: AppTextStyles.subheading,
                    ),
                    const SizedBox(height: 30),

                    AuthTextField(
                      label: AppStrings.newPasswordLabel,
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    AuthTextField(
                      label: AppStrings.confirmPasswordLabel,
                      controller: _confirmController,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    if (_errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          _errorText!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: PillButton(
                        text: AppStrings.resetPassword,
                        backgroundColor: AppColors.secondaryDark,
                        textStyle: AppTextStyles.buttonTextWhite,
                        isLoading: _isLoading,
                        onPressed: _handleReset,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}