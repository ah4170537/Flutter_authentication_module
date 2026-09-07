import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle brandTitle = TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
  );

  static const TextStyle brandSubtitle = TextStyle(
    color: AppColors.white,
    fontSize: 12,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle heading = TextStyle(
    color: AppColors.textDark,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    color: AppColors.textGrey,
    fontSize: 14,
  );

  static const TextStyle fieldLabel = TextStyle(
    color: AppColors.textGrey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle fieldValue = TextStyle(
    color: AppColors.textDark,
    fontSize: 15,
  );

  static const TextStyle linkTeal = TextStyle(
    color: AppColors.primaryLight,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle footerText = TextStyle(
    color: AppColors.textGrey,
    fontSize: 13,
  );

  static const TextStyle buttonTextDark = TextStyle(
    color: AppColors.primaryLight,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle buttonTextTeal = TextStyle(
    color: AppColors.secondaryDark,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle companyInfo = TextStyle(
    color: Color(0xE6FFFFFF),
    fontSize: 13,
    height: 1.6,
  );

  static const TextStyle headerSubtitle = TextStyle(
    color: Color(0xB3FFFFFF),
    fontSize: 13,
  );

  static const TextStyle buttonTextWhite = TextStyle(
    color: AppColors.white,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle productName = TextStyle(
    color: AppColors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle productPrice = TextStyle(
    color: AppColors.white.withValues(alpha: 0.8),
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );
}