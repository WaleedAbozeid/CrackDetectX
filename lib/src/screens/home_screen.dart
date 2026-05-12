import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../store/app_state.dart';
import '../models/marketplace_full_models.dart';
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
import 'marketplace_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final role = context.watch<AppState>().currentUserRole;
    final isCompany = role == UserRole.companyAdmin;
    final isOwner = role == UserRole.owner;
    final isEngineer = role == UserRole.engineer;

    // Define tabs based on role
    final List<_NavigationTab> tabs = [];
    if (isCompany) {
      tabs.add(_NavigationTab(l10n.navHome, Icons.home_outlined, Icons.home, () {}));
      tabs.add(_NavigationTab(l10n.navMarket, Icons.store_outlined, Icons.store, () => _nav(const MarketplaceScreen())));
      tabs.add(_NavigationTab(l10n.navProfile, Icons.person_outline, Icons.person, () => _nav(const ProfileScreen())));
    } else if (isOwner) {
      tabs.add(_NavigationTab(l10n.navHome, Icons.home_outlined, Icons.home, () {}));
      tabs.add(_NavigationTab(l10n.navReports, Icons.description_outlined, Icons.description, () => _nav(const ReportsListScreen())));
      tabs.add(_NavigationTab(l10n.navMarket, Icons.store_outlined, Icons.store, () => _nav(const MarketplaceScreen())));
      tabs.add(_NavigationTab(l10n.navProfile, Icons.person_outline, Icons.person, () => _nav(const ProfileScreen())));
    } else {
      // Engineer (default)
      tabs.add(_NavigationTab(l10n.navHome, Icons.home_outlined, Icons.home, () {}));
      tabs.add(_NavigationTab(l10n.navScan, Icons.scanner_outlined, Icons.scanner, () => _nav(const ScanScreen())));
      tabs.add(_NavigationTab(l10n.navReports, Icons.description_outlined, Icons.description, () => _nav(const ReportsListScreen())));
      tabs.add(_NavigationTab(l10n.navMarket, Icons.store_outlined, Icons.store, () => _nav(const MarketplaceScreen())));
      tabs.add(_NavigationTab(l10n.navProfile, Icons.person_outline, Icons.person, () => _nav(const ProfileScreen())));
    }

    if (_currentIndex >= tabs.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.grey50,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) return; // Already on home
          tabs[index].onTap();
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: tabs.map((tab) => BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: tab.label,
        )).toList(),
      ),
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
                                    l10n.homeWelcomeBack,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.primary100,
                                    ),
                                  ),
                                  Text(
                                    l10n.homeBuildingSafety,
                                    style: AppTypography.h3.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        /*   IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: AppColors.white,
                                size: 24,
                              ),
                              onPressed: () =>
                                  _scaffoldKey.currentState?.openEndDrawer(),
                            ),*/
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // AI Status Card (Glass effect) - ONLY for Engineer
                        if (isEngineer)
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
                                        l10n.homeAiModelStatus,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Text(
                                        l10n.homeAiReadyToAnalyze,
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
                    // Action Buttons (Role-specific)
                    if (isEngineer) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.camera_alt,
                              label: l10n.homeScanWithCamera,
                              colors: [AppColors.primary900, AppColors.primary700],
                              onPressed: () => _nav(const ScanScreen()),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.cloud_upload,
                              label: l10n.homeUploadImage,
                              colors: [AppColors.primary500, Colors.cyan],
                              onPressed: () => _nav(const ScanScreen()),
                            ),
                          ),
                        ],
                      ),
                    ] else if (isOwner) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.add_business,
                              label: 'New Request',
                              colors: [AppColors.primary900, AppColors.primary700],
                              onPressed: () => _nav(const MarketplaceScreen()),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.description,
                              label: 'My Reports',
                              colors: [AppColors.primary500, Colors.cyan],
                              onPressed: () => _nav(const ReportsListScreen()),
                            ),
                          ),
                        ],
                      ),
                    ] else if (isCompany) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.store,
                              label: 'Browse Market',
                              colors: [AppColors.primary900, AppColors.primary700],
                              onPressed: () => _nav(const MarketplaceScreen()),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.gavel,
                              label: 'My Bids',
                              colors: [AppColors.primary500, Colors.cyan],
                              onPressed: () => _nav(const MarketplaceScreen()),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                                      l10n.homePreviousReports,
                                      style: AppTypography.h4,
                                    ),
                                    Text(
                                      l10n.inspectionsCount(23),
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
                      l10n.homeQuickStats,
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            value: '47',
                            label: l10n.homeAll,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            value: '12',
                            label: l10n.homeMonth,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            value: '8',
                            label: l10n.highRisk,
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
                l10n.menuTitle,
                style: AppTypography.h2.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            _DrawerItem(
              icon: Icons.person,
              label: l10n.profileTitle,
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
              label: l10n.settingsTitle,
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
              label: l10n.homeAboutAiModel,
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
              label: l10n.homeSupportHelp,
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
  void _nav(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _NavigationTab {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final VoidCallback onTap;

  _NavigationTab(this.label, this.icon, this.activeIcon, this.onTap);
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
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
              isArabic ? label : label.toUpperCase(),
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
