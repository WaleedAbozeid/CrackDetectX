import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        final isDark = appState.themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppTopBar(
            title: 'Settings',
            onBack: () => Navigator.pop(context),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _SettingsSection(
                  title: 'General',
                  children: [
                    _SettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: appState.locale.languageCode == 'ar'
                          ? 'العربية'
                          : 'English',
                      onTap: () => appState.toggleLanguage(),
                    ),
                    _SettingsTile(
                      icon: isDark ? Icons.light_mode : Icons.dark_mode,
                      title: isDark ? 'Light Mode' : 'Dark Mode',
                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) => appState.toggleTheme(),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      trailing: Switch(
                        value: true, // TODO: Implement notifications state
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                _SettingsSection(
                  title: 'Data & Storage',
                  children: [
                    _SettingsTile(
                      icon: Icons.save,
                      title: 'Auto-save Reports',
                      trailing: Switch(
                        value: true, // TODO: Implement auto-save state
                        onChanged: (value) {},
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.delete_sweep,
                      title: 'Clear Cache',
                      onTap: () => _showClearCacheDialog(context),
                    ),
                    _SettingsTile(
                      icon: Icons.storage,
                      title: 'Storage Used',
                      subtitle: '124 MB',
                    ),
                  ],
                ),
                _SettingsSection(
                  title: 'AI Model',
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'Model Version',
                      subtitle: 'v2.1.0',
                    ),
                    _SettingsTile(
                      icon: Icons.system_update,
                      title: 'Check for Updates',
                      onTap: () => _showUpdateDialog(context),
                    ),
                    _SettingsTile(
                      icon: Icons.update,
                      title: 'Auto-update',
                      trailing: Switch(
                        value: false, // TODO: Implement auto-update state
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                _SettingsSection(
                  title: 'About',
                  children: [
                    _SettingsTile(
                      icon: Icons.help,
                      title: 'App Version',
                      subtitle: '1.0.0',
                    ),
                    _SettingsTile(
                      icon: Icons.description,
                      title: 'Terms of Service',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.library_books,
                      title: 'Licenses',
                      onTap: () {},
                    ),
                  ],
                ),
                _SettingsSection(
                  title: 'Support',
                  children: [
                    _SettingsTile(
                      icon: Icons.help_center,
                      title: 'Help Center',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.mail,
                      title: 'Contact Support',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.bug_report,
                      title: 'Report a Bug',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Check for Updates'),
        content: const Text('You are using the latest version'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
