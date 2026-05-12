import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crackdetectx/l10n/app_localizations.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
import '../repositories/marketplace_repository.dart';
import '../core/api_exception.dart';
import 'place_bid_dialog.dart';

class BrowseProjectsScreen extends StatefulWidget {
  const BrowseProjectsScreen({super.key});

  @override
  State<BrowseProjectsScreen> createState() => _BrowseProjectsScreenState();
}

class _BrowseProjectsScreenState extends State<BrowseProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Filter State
  String? _searchQuery;
  double? _minBudget;
  double? _maxBudget;
  String? _location;

  // API State
  bool _isLoading = false;
  String? _errorMsg;
  List<RepairRequest> _apiRequests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final requests = await MarketplaceRepository.instance.getRequests();
      if (!mounted) return;
      setState(() => _apiRequests = requests);
      // Also sync into AppState so other screens benefit
      final appState = context.read<AppState>();
      for (final r in requests) {
        if (!appState.marketRequests.any((e) => e.id == r.id)) {
          appState.createRepairRequest(r);
        }
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (_) {
      // Silently fall back to AppState cache
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.availableProjects,
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AppState>(
        builder: (context, appState, _) {
          // Merge API results + local AppState
          final allRequests = {
            for (final r in _apiRequests) r.id: r,
            for (final r in appState.marketRequests) r.id: r,
          }.values.toList();

          final availableRequests = allRequests.where((r) {
            if (_searchQuery != null && _searchQuery!.isNotEmpty) {
              final q = _searchQuery!.toLowerCase();
              if (!r.title.toLowerCase().contains(q) &&
                  !r.description.toLowerCase().contains(q)) {
                return false;
              }
            }
            if (_minBudget != null && (r.budgetMax ?? 0) < _minBudget!) return false;
            if (_maxBudget != null && (r.budgetMin ?? double.infinity) > _maxBudget!) return false;
            if (_location != null && !r.location.contains(_location!)) return false;
            return true;
          }).toList();

          return Column(
            children: [
              // Search Header
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: l10n.searchProjectsHint,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.grey400,
                          ),
                          filled: true,
                          fillColor: AppColors.grey50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    InkWell(
                      onTap: () => _showFilterSheet(context, l10n),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              (_minBudget != null ||
                                  _maxBudget != null ||
                                  _location != null)
                              ? AppColors.primary100
                              : AppColors.grey50,
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                        child: Icon(
                          Icons.tune,
                          color:
                              (_minBudget != null ||
                                  _maxBudget != null ||
                                  _location != null)
                              ? AppColors.primary500
                              : AppColors.grey600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_errorMsg != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  color: AppColors.dangerRed.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: AppColors.dangerRed, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(_errorMsg!, style: AppTypography.caption.copyWith(color: AppColors.dangerRed))),
                      TextButton(
                        onPressed: _loadRequests,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: availableRequests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: AppColors.grey400,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              l10n.noProjectsMatch,
                              style: AppTypography.h4.copyWith(
                                color: AppColors.grey600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = null;
                                  _searchController.clear();
                                  _minBudget = null;
                                  _maxBudget = null;
                                  _location = null;
                                });
                              },
                              child: Text(l10n.clearFilters),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadRequests,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount: availableRequests.length,
                          itemBuilder: (context, index) {
                            final request = availableRequests[index];
                            return _ProjectCard(
                              request: request,
                              onTap: () =>
                                  _showPlaceBidDialog(context, request, l10n),
                              l10n: l10n,
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
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
                Text(l10n.filterProjects, style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xl),

                Text(
                  '${l10n.listingBudgetTitle} (${l10n.currencyEGP})',
                  style: AppTypography.h4,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _minBudget?.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.min,
                          suffixText: l10n.currencyEGP,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (v) => _minBudget = double.tryParse(v),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        initialValue: _maxBudget?.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.max,
                          suffixText: l10n.currencyEGP,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (v) => _maxBudget = double.tryParse(v),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),
                Text(l10n.locationTitle, style: AppTypography.h4),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String>(
                  initialValue: _location,
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
                  onChanged: (value) => setSheetState(() => _location = value),
                ),

                const SizedBox(height: AppSpacing.xxl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _minBudget = null;
                            _maxBudget = null;
                            _location = null;
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(l10n.actionClear),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {}); // Trigger rebuild with new values
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaceBidDialog(
    BuildContext context,
    RepairRequest request,
    AppLocalizations l10n,
  ) {
    final appState = Provider.of<AppState>(context, listen: false);
    final user = appState.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseLoginBid)));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => PlaceBidDialog(
        request: request,
        engineerId: user.id,
        engineerName:
            user.fullName,
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final RepairRequest request;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _ProjectCard({
    required this.request,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.title,
                      style: AppTypography.h4,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    child: Text(
                      l10n.openStatus,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                request.description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request.location,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const Spacer(),
                  if (request.budgetMin != null || request.budgetMax != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '${request.budgetMin?.toInt() ?? 0} - ${request.budgetMax?.toInt() ?? '∞'} ${l10n.currencyEGP}',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                    ),
                    child: Text(l10n.placeBid),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
