import 'package:flutter/material.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../design/shadows.dart';
import 'create_listing_screen.dart';
import 'browse_companies_screen.dart';
import 'my_requests_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import 'browse_projects_screen.dart';
import 'place_bid_dialog.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Filter State
  String? _selectedStatus;
  RangeValues _priceRange = const RangeValues(0, 100000); // 0 to 500k

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.marketplaceScreenTitle,
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.primary900),
            onPressed: _showFilterSheet,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: TabBar(
                controller: _tabController,

                indicator: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  boxShadow: AppShadows.small,
                ),
                labelColor: AppColors.primary900,
                unselectedLabelColor: AppColors.grey500,
                labelStyle: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.tabOwner),
                  Tab(text: AppLocalizations.of(context)!.tabCompany),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe to change tabs
        children: [_buildOwnerView(), _buildCompanyView()],
      ),
    );
  }

  Widget _buildOwnerView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchHint,
              hintStyle: AppTypography.bodyMedium,
              prefixIcon: const Icon(Icons.search, color: AppColors.grey400),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.r12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: AppSpacing.md,
              ),
            ),
            onChanged: (value) {
              // TODO: Implement search filtering
              setState(() {});
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Main Actions
          _buildActionCard(
            title: AppLocalizations.of(context)!.createListing,
            subtitle: AppLocalizations.of(context)!.createListingSubtitle,
            icon: Icons.add_circle_outline,
            color: AppColors.primary500,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateListingScreen()),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  title: AppLocalizations.of(context)!.myListings,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.activeListingsCount('3'),
                  icon: Icons.list_alt,
                  color: AppColors.secondary500,
                  isSmall: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyRequestsScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildActionCard(
                  title: AppLocalizations.of(context)!.companies,
                  subtitle: AppLocalizations.of(context)!.browseAll,
                  icon: Icons.business,
                  color: AppColors.warningOrange,
                  isSmall: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BrowseCompaniesScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
          Text(
            AppLocalizations.of(context)!.recommendedCompanies,
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.md),
          // TODO: Add list of recommended companies
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                AppLocalizations.of(context)!.noCompaniesFound,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyView() {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return Center(
            child: Text(AppLocalizations.of(context)!.loginForCompanyView),
          );
        }

        // Get my active bids
        final myBids = appState.bids
            .where(
              (b) => b.engineerId == user.uid && b.status == BidStatus.pending,
            )
            .toList();

        // Get recent available projects
        final recentProjects = appState
            .getPublicRequests(); // In real app, apply filters here

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Summary
              if (myBids.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.activeBids,
                  style: AppTypography.h4,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myBids.length,
                    itemBuilder: (context, index) {
                      final bid = myBids[index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          border: Border.all(color: AppColors.primary100),
                          boxShadow: AppShadows.small,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bid #${bid.id.substring(bid.id.length - 4)}',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AppLocalizations.of(context)!.currencyEGP} ${bid.price.toStringAsFixed(0)}',
                              style: AppTypography.h3,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.statusPending,
                                style: AppTypography.caption.copyWith(
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Available Projects List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.recentOpportunities,
                    style: AppTypography.h4,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrowseProjectsScreen(),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              if (recentProjects.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.work_off_outlined,
                          size: 48,
                          color: AppColors.grey400,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          AppLocalizations.of(context)!.noProjectsAvailable,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentProjects.take(5).length,
                  itemBuilder: (context, index) {
                    final request = recentProjects[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                        side: BorderSide(color: AppColors.grey200),
                      ),
                      child: ListTile(
                        title: Text(
                          request.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(request.location),
                        trailing: const Icon(Icons.chevron_right),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 4,
                        ),
                        onTap: () {
                          // Navigate to details (reusing existing logic or creating new)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlaceBidDialog(
                                request: request,
                                engineerId: user.uid,
                                engineerName: user.displayName ?? 'Engineer',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r20),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSheet) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.filterTitle,
                  style: AppTypography.h3,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  AppLocalizations.of(context)!.filterStatus,
                  style: AppTypography.h4,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildFilterChip(
                      AppLocalizations.of(context)!.statusAll,
                      null,
                      _selectedStatus,
                      (v) => setStateSheet(() => _selectedStatus = v),
                    ),
                    _buildFilterChip(
                      AppLocalizations.of(context)!.statusOpen,
                      'open',
                      _selectedStatus,
                      (v) => setStateSheet(() => _selectedStatus = v),
                    ),
                    _buildFilterChip(
                      AppLocalizations.of(context)!.statusUrgent,
                      'urgent',
                      _selectedStatus,
                      (v) => setStateSheet(() => _selectedStatus = v),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  AppLocalizations.of(context)!.filterBudget,
                  style: AppTypography.h4,
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 500000,
                  divisions: 10,
                  labels: RangeLabels(
                    '${_priceRange.start.round()}',
                    '${_priceRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setStateSheet(() => _priceRange = values);
                  },
                  activeColor: AppColors.primary500,
                ),

                const SizedBox(height: AppSpacing.xxl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedStatus = null;
                            _priceRange = const RangeValues(0, 100000);
                          });
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.actionClear),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {}); // Trigger rebuild to apply filters
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                        ),
                        child: Text(AppLocalizations.of(context)!.actionApply),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String? value,
    String? groupValue,
    Function(String?) onTap,
  ) {
    final isSelected = groupValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onTap(selected ? value : null),
      selectedColor: AppColors.primary100,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary900 : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isSmall = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: AppShadows.small,
        ),
        child: Row(
          children: [
            Container(
              width: isSmall ? 40 : 48,
              height: isSmall ? 40 : 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: color, size: isSmall ? 20 : 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.h4),
                  if (!isSmall) const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            if (!isSmall) Icon(Icons.chevron_right, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
