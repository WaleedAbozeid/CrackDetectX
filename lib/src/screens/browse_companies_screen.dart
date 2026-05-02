import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import 'company_profile_screen.dart';

class BrowseCompaniesScreen extends StatefulWidget {
  const BrowseCompaniesScreen({super.key});

  @override
  State<BrowseCompaniesScreen> createState() => _BrowseCompaniesScreenState();
}

class _BrowseCompaniesScreenState extends State<BrowseCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _activeFilters = [];

  // Filter State
  String? _searchQuery;
  String? _selectedRating; // "4", "4.5"
  String? _selectedLocation;
  bool _verifiedOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilters(AppLocalizations l10n) {
    setState(() {
      _activeFilters.clear();
      if (_selectedRating != null) {
        _activeFilters.add(l10n.starsPlus(_selectedRating!));
      }
      if (_selectedLocation != null) {
        _activeFilters.add('$_selectedLocation');
      }
      if (_verifiedOnly) {
        _activeFilters.add(l10n.verifiedOnly);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.primary900),
        title: Text(
          l10n.browseCompanies,
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final companies = appState.getCompanies(
            query: _searchQuery,
            minRating: _selectedRating != null
                ? double.parse(_selectedRating!)
                : null,
            location: _selectedLocation,
            verifiedOnly: _verifiedOnly,
          );

          return Column(
            children: [
              // Search & Filters Header
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.grey400,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.tune,
                            color: AppColors.primary500,
                          ),
                          onPressed: () => _showFilterSheet(context, l10n),
                        ),
                        filled: true,
                        fillColor: AppColors.grey50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                    if (_activeFilters.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _activeFilters.length + 1,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            if (index == _activeFilters.length) {
                              return ActionChip(
                                label: Text(l10n.actionClear),
                                onPressed: () {
                                  setState(() {
                                    _selectedRating = null;
                                    _selectedLocation = null;
                                    _verifiedOnly = false;
                                    _activeFilters.clear();
                                  });
                                },
                                backgroundColor: AppColors.grey200,
                              );
                            }
                            return Chip(
                              label: Text(_activeFilters[index]),
                              backgroundColor: AppColors.primary100,
                              labelStyle: const TextStyle(
                                color: AppColors.primary900,
                              ),
                              deleteIconColor: AppColors.primary900,
                              onDeleted: () {
                                setState(() {
                                  final filter = _activeFilters[index];
                                  if (filter.contains(
                                    l10n.starsPlus('4.0').replaceAll('4.0', ''),
                                  )) {
                                    _selectedRating = null;
                                  }
                                  if (filter == l10n.verifiedOnly) {
                                    _verifiedOnly = false;
                                  }
                                  if (filter == _selectedLocation) {
                                    _selectedLocation = null;
                                  }
                                  _updateFilters(l10n);
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Company List
              Expanded(
                child: companies.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noCompaniesFound,
                          style: AppTypography.bodyText.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: companies.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) =>
                            _buildCompanyCard(companies[index], l10n),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompanyCard(Company company, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompanyProfileScreen(
                companyData: {
                  'name': company.name,
                  'rating': company.rating,
                  'reviews': company.reviewCount,
                  'verified': company.isVerified,
                  'topRated': company.isTopRated,
                  'description': company.description,
                  'location': company.location,
                  'projects': company.projectsCompleted,
                  'specializations': company.specializations
                      .map((e) => e.name)
                      .toList(),
                  'logo': company.logoUrl,
                },
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.grey200,
                    child: const Icon(Icons.business, color: AppColors.grey500),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                company.name,
                                style: AppTypography.h4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (company.isVerified)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.verified,
                                  color: AppColors.successGreen,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.warningOrange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${company.rating} (${l10n.reviewsCount(company.reviewCount)})',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (company.isTopRated)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        l10n.topRated,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.warningDark,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                company.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(company.location, style: AppTypography.bodySmall),
                  const SizedBox(width: AppSpacing.lg),
                  const Icon(
                    Icons.work,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.projectsCount(company.projectsCompleted),
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: company.specializations.take(3).map((spec) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    child: Text(spec.name, style: AppTypography.caption),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setSheetState) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.filterCompanies, style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xl),

                Text(l10n.ratingTitle, style: AppTypography.h4),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text(l10n.starsPlus('4.0')),
                      selected: _selectedRating == '4.0',
                      onSelected: (selected) => setSheetState(
                        () => _selectedRating = selected ? '4.0' : null,
                      ),
                    ),
                    FilterChip(
                      label: Text(l10n.starsPlus('4.5')),
                      selected: _selectedRating == '4.5',
                      onSelected: (selected) => setSheetState(
                        () => _selectedRating = selected ? '4.5' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),
                CheckboxListTile(
                  title: Text(l10n.verifiedOnly),
                  value: _verifiedOnly,
                  onChanged: (v) =>
                      setSheetState(() => _verifiedOnly = v ?? false),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: AppSpacing.md),
                Text(l10n.locationTitle, style: AppTypography.h4),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String>(
                  initialValue: _selectedLocation,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.allLocations),
                    ),
                    const DropdownMenuItem(
                      value: 'Cairo',
                      child: Text('Cairo'),
                    ),
                    const DropdownMenuItem(value: 'Giza', child: Text('Giza')),
                    const DropdownMenuItem(
                      value: 'Alexandria',
                      child: Text('Alexandria'),
                    ),
                  ],
                  onChanged: (value) =>
                      setSheetState(() => _selectedLocation = value),
                ),

                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _updateFilters(l10n);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(l10n.actionApply),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
