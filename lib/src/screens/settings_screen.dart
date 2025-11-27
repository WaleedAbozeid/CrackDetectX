import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'English';
  bool _darkMode = false;
  bool _notifications = true;
  bool _autoSave = true;
  bool _autoUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
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
                  subtitle: _language,
                  onTap: () => _showLanguageDialog(),
                ),
                _SettingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() => _darkMode = value);
                    },
                  ),
                ),
                _SettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  trailing: Switch(
                    value: _notifications,
                    onChanged: (value) {
                      setState(() => _notifications = value);
                    },
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
                    value: _autoSave,
                    onChanged: (value) {
                      setState(() => _autoSave = value);
                    },
                  ),
                ),
                _SettingsTile(
                  icon: Icons.delete_sweep,
                  title: 'Clear Cache',
                  onTap: () => _showClearCacheDialog(),
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
                  onTap: () => _showUpdateDialog(),
                ),
                _SettingsTile(
                  icon: Icons.update,
                  title: 'Auto-update',
                  trailing: Switch(
                    value: _autoUpdate,
                    onChanged: (value) {
                      setState(() => _autoUpdate = value);
                    },
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
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                setState(() => _language = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                setState(() => _language = 'العربية');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog() {
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

  const _SettingsSection({
    required this.title,
    required this.children,
  });

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
              color: AppColors.primary900,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.grey200),
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
    return ListTile(
      leading: Icon(icon, color: AppColors.primary900),
      title: Text(title, style: AppTypography.h4),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTypography.caption)
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
    );
  }
}
