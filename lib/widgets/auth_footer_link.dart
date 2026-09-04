import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme/app_text_styles.dart';


class AuthFooterLink extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: promptText,
        style: AppTextStyles.footerText,
        children: [
          TextSpan(
            text: actionText,
            style: AppTextStyles.linkTeal,
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}