import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../store/app_state.dart';
import '../models/marketplace_models.dart';
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

  @override
  void dispose() {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Available Projects',
          style: AppTypography.h3.copyWith(color: AppColors.primary900),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final availableRequests = appState.getPublicRequests(
            query: _searchQuery,
            minBudget: _minBudget,
            maxBudget: _maxBudget,
            location: _location,
          );

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
                          hintText: 'Search projects...',
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
                      onTap: _showFilterSheet,
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
                              'No projects match your search',
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
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: availableRequests.length,
                        itemBuilder: (context, index) {
                          final request = availableRequests[index];
                          return _ProjectCard(
                            request: request,
                            onTap: () => _showPlaceBidDialog(context, request),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
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
                Text('Filter Projects', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.xl),

                Text('Budget Range (EGP)', style: AppTypography.h4),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _minBudget?.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min',
                          suffixText: 'EGP',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => _minBudget = double.tryParse(v),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        initialValue: _maxBudget?.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max',
                          suffixText: 'EGP',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => _maxBudget = double.tryParse(v),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),
                Text('Location', style: AppTypography.h4),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String>(
                  value: _location,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All Locations')),
                    DropdownMenuItem(value: 'Cairo', child: Text('Cairo')),
                    DropdownMenuItem(value: 'Giza', child: Text('Giza')),
                    DropdownMenuItem(
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
                        child: const Text('Clear'),
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
                        child: const Text('Apply'),
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

  void _showPlaceBidDialog(BuildContext context, RepairRequest request) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to place a bid')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => PlaceBidDialog(
        request: request,
        engineerId: user.uid,
        engineerName:
            user.displayName ?? user.email?.split('@')[0] ?? 'Engineer',
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final RepairRequest request;
  final VoidCallback onTap;

  const _ProjectCard({required this.request, required this.onTap});

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
                      'Open',
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
                        '${request.budgetMin?.toInt() ?? 0} - ${request.budgetMax?.toInt() ?? '∞'} EGP',
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
                    child: const Text('Place Bid'),
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
