import 'package:flutter/material.dart';
import '../widgets/card.dart' as app_card;
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';
import '../design/shadows.dart';
import 'scan_screen.dart';
import 'reports_list_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'about_ai_screen.dart';
import 'support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.grey50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section with Gradient
            SliverAppBar(
              expandedHeight: 220,
              backgroundColor: AppColors.primary900,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary900,
                        AppColors.primary700,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppRadius.r28),
                      bottomRight: Radius.circular(AppRadius.r28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar with Welcome and Menu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.primary100,
                                    ),
                                  ),
                                  Text(
                                    'Building Safety',
                                    style: AppTypography.h3.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: AppColors.white,
                                size: 24,
                              ),
                              onPressed: () =>
                                  _scaffoldKey.currentState?.openEndDrawer(),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // AI Status Card (Glass effect)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            border: Border.all(
                              color: Colors.white.withAlpha((0.2 * 255).toInt()),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.successGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AI Model Status',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Text(
                                      'Ready to analyze',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.primary100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Icon(
                                Icons.brightness_1,
                                color: AppColors.successGreen,
                                size: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.camera_alt,
                            label: 'Scan with Camera',
                            colors: [AppColors.primary900, AppColors.primary700],
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ScanScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.cloud_upload,
                            label: 'Upload Image',
                            colors: [AppColors.primary500, Colors.cyan],
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ScanScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Previous Reports Card
                    app_card.AppCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary100,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.r12),
                                  ),
                                  child: const Icon(
                                    Icons.history,
                                    color: AppColors.primary900,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Previous Reports',
                                      style: AppTypography.h4,
                                    ),
                                    Text(
                                      '23 inspections',
                                      style: AppTypography.caption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ReportsListScreen(),
                                ),
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Quick Stats
                    Text(
                      'Quick Stats',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            value: '47',
                            label: 'All',
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            value: '12',
                            label: 'Month',
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            value: '8',
                            label: 'High Risk',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Drawer (Menu)
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary900,
              ),
              child: Text(
                'Menu',
                style: AppTypography.h2.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            _DrawerItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.psychology,
              label: 'About AI Model',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutAIScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.help_center,
              label: 'Support & Help',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SupportScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.r20),
          boxShadow: AppShadows.floating,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: 24),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return app_card.AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.h1.copyWith(
                color: AppColors.primary900,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label.toUpperCase(),
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary900),
      title: Text(label, style: AppTypography.h4),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
    );
  }
}
