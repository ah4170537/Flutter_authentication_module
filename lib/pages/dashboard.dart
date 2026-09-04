import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_strings.dart';
import '../widgets/stat_card.dart';
import '../widgets/menu_tile.dart';
import '../services/auth_service.dart';
import 'login.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.signOut();

    if (!context.mounted) return;


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppGradients.welcomeBackground,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.dashboardWelcome,
                            style: AppTextStyles.brandTitle,
                          ),
                          SizedBox(height: 4),
                          Text(
                            AppStrings.dashboardSubtitle,
                            style: AppTextStyles.headerSubtitle,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _logout(context),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.logout,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.folder_outlined,
                        value: "12",
                        label: AppStrings.statProjects,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.task_alt,
                        value: "34",
                        label: AppStrings.statTasks,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.notifications_none,
                        value: "5",
                        label: AppStrings.statAlerts,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
              child: Text(
                AppStrings.quickActions,
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  MenuTile(
                    icon: Icons.person_outline,
                    label: AppStrings.menuProfile,
                    onTap: () {},
                  ),
                  MenuTile(
                    icon: Icons.settings_outlined,
                    label: AppStrings.menuSettings,
                    onTap: () {},
                  ),
                  MenuTile(
                    icon: Icons.notifications_none,
                    label: AppStrings.menuNotifications,
                    onTap: () {},
                  ),
                  MenuTile(
                    icon: Icons.help_outline,
                    label: AppStrings.menuHelp,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
