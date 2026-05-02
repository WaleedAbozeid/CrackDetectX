import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../store/app_state.dart';
import '../widgets/app_top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final l10n = AppLocalizations.of(context)!;
        final isDark = appState.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppTopBar(
            title: l10n.settingsTitle,
            onBack: () => Navigator.pop(context),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _SettingsSection(
                  title: l10n.settingsSectionGeneral,
                  children: [
                    _SettingsTile(
                      icon: Icons.language,
                      title: l10n.settingsLanguage,
                      subtitle: appState.locale.languageCode == 'ar'
                          ? l10n.languageAr
                          : l10n.languageEn,
                      onTap: () => appState.toggleLanguage(),
                    ),
                    _SettingsTile(
                      icon: isDark ? Icons.light_mode : Icons.dark_mode,
                      title: isDark ? l10n.lightMode : l10n.darkMode,
                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) => appState.toggleTheme(),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.notifications,
                      title: l10n.settingsNotifications,
                      trailing: Switch(
                        value: true, // TODO: Implement notifications state
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                _SettingsSection(
                  title: l10n.settingsSectionDataStorage,
                  children: [
                    _SettingsTile(
                      icon: Icons.save,
                      title: l10n.settingsAutoSaveReports,
                      trailing: Switch(
                        value: true, // TODO: Implement auto-save state
                        onChanged: (value) {},
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.wifi_off,
                      title: l10n.settingsOfflineMode,
                      subtitle: appState.isOnline
                          ? l10n.settingsOnline
                          : l10n.settingsOffline,
                      trailing: Switch(
                        value: !appState.isOnline,
                        onChanged: (value) => appState.setOnline(!value),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.delete_sweep,
                      title: l10n.settingsClearCache,
                      onTap: () => _showClearCacheDialog(context),
                    ),
                    _SettingsTile(
                      icon: Icons.storage,
                      title: l10n.settingsStorageUsed,
                      subtitle: '124 MB',
                    ),
                  ],
                ),
                _SettingsSection(
                  title: l10n.settingsSectionAiModel,
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: l10n.settingsModelVersion,
                      subtitle: 'v2.1.0',
                    ),
                    _SettingsTile(
                      icon: Icons.system_update,
                      title: l10n.settingsCheckUpdates,
                      onTap: () => _showUpdateDialog(context),
                    ),
                    _SettingsTile(
                      icon: Icons.update,
                      title: l10n.settingsAutoUpdate,
                      trailing: Switch(
                        value: false, // TODO: Implement auto-update state
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                _SettingsSection(
                  title: l10n.settingsSectionAbout,
                  children: [
                    _SettingsTile(
                      icon: Icons.help,
                      title: l10n.settingsAppVersion,
                      subtitle: '1.0.0',
                    ),
                    _SettingsTile(
                      icon: Icons.description,
                      title: l10n.settingsTermsOfService,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip,
                      title: l10n.settingsPrivacyPolicy,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.library_books,
                      title: l10n.settingsLicenses,
                      onTap: () {},
                    ),
                  ],
                ),
                _SettingsSection(
                  title: l10n.settingsSectionSupport,
                  children: [
                    _SettingsTile(
                      icon: Icons.help_center,
                      title: l10n.settingsHelpCenter,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.mail,
                      title: l10n.settingsContactSupport,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.bug_report,
                      title: l10n.settingsReportBug,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dialogClearCacheTitle),
        content: Text(l10n.dialogClearCacheBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(content: Text(l10n.snackCacheCleared)),
              );
            },
            child: Text(l10n.actionClear),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dialogCheckUpdatesTitle),
        content: Text(l10n.dialogCheckUpdatesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Text(
            title,
            style: AppTypography.h4.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.primary900,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.grey900;
    final iconColor = Theme.of(context).iconTheme.color ?? AppColors.primary900;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: AppTypography.h4.copyWith(color: textColor)),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.caption.copyWith(
                color: textColor.withValues(alpha: 0.7),
              ),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
    );
  }
}
