import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/building_models.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../core/constants.dart';
import 'add_building_screen.dart';

/// Screen shown before the scan — lets the engineer pick a building or skip.
///
/// Navigation:
/// - Back  → previous screen
/// - Tap building card → saves selection in AppState, goes to ScanScreen
/// - "+" button → AddBuildingScreen
/// - "Skip" → goes to ScanScreen without a building linked
class SelectBuildingScreen extends StatelessWidget {
  const SelectBuildingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final buildings = appState.buildings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('اختر المبنى', style: AppTypography.h3),
        backgroundColor: AppColors.primary500,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _goToScan(context, null),
            child: Text(
              'تخطي',
              style: AppTypography.bodySmall.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddBuildingScreen()),
        ),
        backgroundColor: AppColors.primary500,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('مبنى جديد',
            style: AppTypography.button.copyWith(color: AppColors.white)),
      ),
      body: buildings.isEmpty
          ? _EmptyState(onAdd: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBuildingScreen()),
              ))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: buildings.length,
              itemBuilder: (_, i) => _BuildingCard(
                building: buildings[i],
                onTap: () => _goToScan(context, buildings[i].id),
              ),
            ),
    );
  }

  void _goToScan(BuildContext context, String? buildingId) {
    // Store selected buildingId in AppState then navigate to scan
    context.read<AppState>().setSelectedBuilding(buildingId);
    Navigator.pushNamed(context, AppConstants.routeScan);
  }
}

class _BuildingCard extends StatelessWidget {
  final Building building;
  final VoidCallback onTap;

  const _BuildingCard({required this.building, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: const Icon(Icons.apartment, color: AppColors.primary500),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(building.name, style: AppTypography.h4),
                    const SizedBox(height: 2),
                    Text(building.address,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                    if (building.yearBuilt != null)
                      Text('سنة البناء: ${building.yearBuilt}',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.grey500)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.grey400),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, size: 64, color: AppColors.grey300),
          const SizedBox(height: AppSpacing.md),
          Text('لا توجد مبانٍ مضافة', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Text('أضف مبنى لربط الفحوصات به',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('إضافة مبنى'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500),
          ),
        ],
      ),
    );
  }
}
