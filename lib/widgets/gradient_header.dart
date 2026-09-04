import 'package:flutter/material.dart';
import '../theme/app_gradients.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';


class GradientHeader extends StatelessWidget {
  final double height;
  final double logoSize;
  final TextStyle? brandStyle;

  const GradientHeader({
    super.key,
    this.height = 200,
    this.logoSize = 55,
    this.brandStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(60),
        bottomRight: Radius.circular(60),
      ),
      child: Container(
        width: double.infinity,
        height: height, 
        decoration: const BoxDecoration(
          gradient: AppGradients.welcomeBackground,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: logoSize, 
                width: logoSize,  
                fit: BoxFit.contain, 
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.flare,
                  size: logoSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppStrings.brandName,
                  textAlign: TextAlign.center,
                  style: brandStyle ?? AppTextStyles.brandSubtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}