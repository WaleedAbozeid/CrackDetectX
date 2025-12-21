import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../store/app_state.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';
import 'scan_screen.dart';
import 'reports_list_screen.dart';
import 'profile_screen.dart';
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
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final user = FirebaseAuth.instance.currentUser;
        String userName = user?.displayName ?? '';
        if (userName.isEmpty && user?.email != null) {
          userName = user!.email!.split('@')[0];
        } else if (userName.isEmpty) {
          userName = 'User';
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              switch (index) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScanScreen()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportsListScreen(),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MarketplaceScreen(),
                    ),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).cardColor,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).disabledColor,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: AppLocalizations.of(context)!.navHome,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.scanner_outlined),
                activeIcon: const Icon(Icons.scanner),
                label: AppLocalizations.of(context)!.navScan,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.description_outlined),
                activeIcon: const Icon(Icons.description),
                label: AppLocalizations.of(context)!.navReports,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.store_outlined),
                activeIcon: const Icon(Icons.store),
                label: AppLocalizations.of(context)!.navMarket,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: AppLocalizations.of(context)!.navProfile,
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Blue Header Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB), // Figma Blue
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.r32),
                        bottomRight: Radius.circular(AppRadius.r32),
                      ),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row (Lang, Theme, Notif) - Simplified for design match
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.translate,
                              color: AppColors.white.withValues(alpha: 0.8),
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Icon(
                              Icons.wb_sunny_outlined,
                              color: AppColors.white.withValues(alpha: 0.8),
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Icon(
                              Icons.notifications_none,
                              color: AppColors.white.withValues(alpha: 0.8),
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Welcome Text
                        Text(
                          '${AppLocalizations.of(context)!.welcomeBack} $userName 👋',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.white,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.scanBuilding,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Stats Row (Dark Cards)
                        Row(
                          children: [
                            Expanded(
                              child: _DarkStatCard(
                                icon: Icons.filter_center_focus,
                                value: '24',
                                label: AppLocalizations.of(context)!.scans,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _DarkStatCard(
                                icon: Icons.trending_up,
                                value: '87%',
                                label: AppLocalizations.of(context)!.avgHealth,
                                color: AppColors.successGreen,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _DarkStatCard(
                                icon: Icons.warning_amber_rounded,
                                value: '3',
                                label: AppLocalizations.of(
                                  context,
                                )!.cracksDetected,
                                color: AppColors.warningOrange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),

                  // Body Content
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Start Scan Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.r24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF2563EB,
                                ).withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.startNewScan,
                                        style: AppTypography.h3.copyWith(
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.scanSubtitle,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.r12,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.center_focus_strong,
                                      color: AppColors.white,
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ScanScreen(),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF10B981,
                                    ), // Figma Green
                                    foregroundColor: AppColors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.r12,
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.startScanNow,
                                    style: AppTypography.button,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Recent Scans Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.recentScans,
                              style: AppTypography.h3.copyWith(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.white
                                    : AppColors.primary900,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ReportsListScreen(),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.viewAll,
                                style: AppTypography.bodySmall.copyWith(
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Recent Scan Item (Mock)
                        _RecentScanItem(
                          title: 'Residential Building - Cairo',
                          date: '2025-12-14',
                          risk: 'Low',
                          health: 85,
                          imagePath:
                              'assets/images/building_mock.jpg', // Placeholder
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _RecentScanItem(
                          title: 'Commercial Complex - Giza',
                          date: '2025-12-13',
                          risk: 'Moderate',
                          health: 72,
                          imagePath:
                              'assets/images/building_mock_2.jpg', // Placeholder
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Marketplace Card (White Card at bottom)
                        const _MarketplaceCard(),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DarkStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _DarkStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark Slate
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: AppColors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.grey400,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RecentScanItem extends StatelessWidget {
  final String title;
  final String date;
  final String risk;
  final int health;
  final String imagePath;

  const _RecentScanItem({
    required this.title,
    required this.date,
    required this.risk,
    required this.health,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              image: const DecorationImage(
                // Using a network placeholder if asset not found for demo
                image: NetworkImage('https://placehold.co/100x100/png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Icon(
              Icons.image_not_supported,
              color: AppColors.grey500,
            ), // Fallback
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.primary900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 4),
                    Text(date, style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 14,
                      color: const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$health%',
                      style: AppTypography.caption.copyWith(
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: risk == 'Low'
                            ? AppColors.successGreen.withValues(alpha: 0.1)
                            : AppColors.warningOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                      child: Text(
                        risk,
                        style: AppTypography.caption.copyWith(
                          color: risk == 'Low'
                              ? AppColors.successGreen
                              : AppColors.warningOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplaceCard extends StatelessWidget {
  const _MarketplaceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF), // Light Purple
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  border: Border.all(color: const Color(0xFFD8B4FE)),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF9333EA),
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.marketTitle,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.marketSubtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2563EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                AppLocalizations.of(context)!.exploreMarket,
                style: AppTypography.button.copyWith(
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
