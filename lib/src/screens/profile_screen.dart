import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Avatar Section
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primary900, AppColors.primary500],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // User Info
              Text(
                'Ahmed Hassan',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'ahmed.hassan@email.com',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Statistics Grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StatBox(
                    value: '47',
                    label: 'Total Scans',
                  ),
                  _StatBox(
                    value: '8',
                    label: 'High Risk',
                  ),
                  _StatBox(
                    value: '12',
                    label: 'This Month',
                  ),
                  _StatBox(
                    value: '2h ago',
                    label: 'Last Activity',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Account Settings
              _SettingCard(
                icon: Icons.person,
                label: 'Edit Profile',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.md),
              _SettingCard(
                icon: Icons.lock,
                label: 'Change Password',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.md),
              _SettingCard(
                icon: Icons.notifications,
                label: 'Notifications',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.md),
              _SettingCard(
                icon: Icons.language,
                label: 'Language',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Danger Zone
              _SettingCard(
                icon: Icons.delete,
                label: 'Delete Account',
                isDestructive: true,
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.lg),

              // Logout Button
              AppButton(
                title: 'Logout',
                height: 48,
                backgroundColor: AppColors.white,
                textColor: AppColors.primary900,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: AppColors.primary900,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: isDestructive ? AppColors.dangerLight : AppColors.grey200,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.dangerRed : AppColors.primary900,
        ),
        title: Text(
          label,
          style: AppTypography.h4.copyWith(
            color: isDestructive ? AppColors.dangerRed : AppColors.grey900,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.grey400,
        ),
        onTap: onTap,
      ),
    );
  }
}
