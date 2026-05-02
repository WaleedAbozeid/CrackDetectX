import 'package:flutter/material.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../widgets/app_button.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';
import '../core/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var displayName = user?.displayName ?? '';
    if (displayName.isEmpty && user?.email != null) {
      displayName = user!.email!.split('@')[0];
    } else if (displayName.isEmpty) {
      displayName = AppLocalizations.of(context)!.defaultUser;
    }
    final email = user?.email ?? AppLocalizations.of(context)!.noEmail;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profileTitle,
          style: AppTypography.h3.copyWith(
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
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
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : 'U',
                        style: AppTypography.h1.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 3),
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
                displayName,
                style: AppTypography.h3.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                email,
                style: AppTypography.bodySmall.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
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
                    value: '0', // TODO: Fetch real stats
                    label: AppLocalizations.of(context)!.totalScans,
                    textColor:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        AppColors.primary900,
                    backgroundColor: Theme.of(context).cardColor,
                  ),
                  _StatBox(
                    value: '0', // TODO: Fetch real stats
                    label: AppLocalizations.of(context)!.highRisk,
                    textColor:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        AppColors.primary900,
                    backgroundColor: Theme.of(context).cardColor,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Account Settings
              _SettingCard(
                icon: Icons.person,
                label: AppLocalizations.of(context)!.editProfile,
                onTap: () {},
                iconColor:
                    Theme.of(context).iconTheme.color ?? AppColors.primary900,
                textColor:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.grey900,
                backgroundColor: Theme.of(context).cardColor,
              ),
              const SizedBox(height: AppSpacing.md),
              _SettingCard(
                icon: Icons.notifications,
                label: AppLocalizations.of(context)!.notifications,
                onTap: () => Navigator.pushNamed(context, '/notifications'),
                iconColor:
                    Theme.of(context).iconTheme.color ?? AppColors.primary900,
                textColor:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.grey900,
                backgroundColor: Theme.of(context).cardColor,
              ),
              const SizedBox(height: AppSpacing.md),
              Consumer<AppState>(
                builder: (context, appState, _) {
                  return _SettingCard(
                    icon: Icons.language,
                    label: appState.locale.languageCode == 'ar'
                        ? AppLocalizations.of(context)!.languageEn
                        : AppLocalizations.of(context)!.languageAr,
                    onTap: () {
                      appState.toggleLanguage();
                    },
                    iconColor:
                        Theme.of(context).iconTheme.color ??
                        AppColors.primary900,
                    textColor:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        AppColors.grey900,
                    backgroundColor: Theme.of(context).cardColor,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Consumer<AppState>(
                builder: (context, appState, _) {
                  return _SettingCard(
                    icon: appState.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    label: appState.themeMode == ThemeMode.dark
                        ? AppLocalizations.of(context)!.lightMode
                        : AppLocalizations.of(context)!.darkMode,
                    onTap: () {
                      appState.toggleTheme();
                    },
                    iconColor:
                        Theme.of(context).iconTheme.color ??
                        AppColors.primary900,
                    textColor:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        AppColors.grey900,
                    backgroundColor: Theme.of(context).cardColor,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Danger Zone
              _SettingCard(
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.deleteAccount,
                isDestructive: true,
                onTap: () {},
                iconColor: AppColors.dangerRed,
                textColor: AppColors.dangerRed,
                backgroundColor: Theme.of(context).cardColor,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Logout Button
              AppButton(
                title: AppLocalizations.of(context)!.logout,
                height: 48,
                backgroundColor: Theme.of(context).cardColor,
                textColor:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    AppColors.primary900,
                useGradient: false,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppConstants.routeOnboarding,
                      (route) => false,
                    );
                  }
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
  final Color textColor;
  final Color backgroundColor;

  const _StatBox({
    required this.value,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.grey200.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTypography.h2.copyWith(color: textColor, fontSize: 24),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: textColor.withValues(alpha: 0.7),
            ),
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
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;

  const _SettingCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    required this.iconColor,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: isDestructive
              ? AppColors.dangerLight
              : AppColors.grey200.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(label, style: AppTypography.h4.copyWith(color: textColor)),
        trailing: Icon(Icons.chevron_right, color: AppColors.grey400),
        onTap: onTap,
      ),
    );
  }
}
