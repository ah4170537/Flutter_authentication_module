import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SocialIconsRow extends StatelessWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onTwitterTap;
  final VoidCallback? onGoogleTap;

  const SocialIconsRow({
    super.key,
    this.onFacebookTap,
    this.onTwitterTap,
    this.onGoogleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon(Icons.facebook, AppColors.facebook, onFacebookTap),
        const SizedBox(width: 20),
        _socialIcon(Icons.alternate_email, AppColors.twitter, onTwitterTap),
        const SizedBox(width: 20),
        _socialIcon(Icons.g_mobiledata, AppColors.google, onGoogleTap),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: color,
        child: Icon(icon, size: 18, color: AppColors.white),
      ),
    );
  }
}