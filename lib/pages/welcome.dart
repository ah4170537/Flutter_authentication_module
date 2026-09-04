import 'package:flutter/material.dart';
import '../theme/app_gradients.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';
import '../widgets/pill_button.dart';
import 'login.dart';
import 'register.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.welcomeBackground,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 120,
                width: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.flare,
                    size: 80,
                    color: AppColors.white,
                  );
                },
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  AppStrings.brandName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.brandTitle,
                ),
              ),
              const SizedBox(height: 100),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: PillButton(
                          text: AppStrings.login,
                          backgroundColor: AppColors.white,
                          textStyle: AppTextStyles.buttonTextDark,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Login()),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: PillButton(
                          text: AppStrings.registerNow,
                          backgroundColor: AppColors.white,
                          textStyle: AppTextStyles.buttonTextTeal,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Register()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45),
                child: Text(
                  AppStrings.companyInfo,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.companyInfo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}