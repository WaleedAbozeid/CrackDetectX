import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../models/building_models.dart';
import '../repositories/building_repository.dart';
import '../core/api_exception.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/radius.dart';
import '../core/constants.dart';
import 'add_building_screen.dart';

/// Screen shown before the scan — lets the engineer pick a building or skip.
///
/// Fetches buildings from the backend on load; falls back to local cache.
class SelectBuildingScreen extends StatefulWidget {
  const SelectBuildingScreen({super.key});

  @override
  State<SelectBuildingScreen> createState() => _SelectBuildingScreenState();
}

class _SelectBuildingScreenState extends State<SelectBuildingScreen> {
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final buildings = await BuildingRepository.instance.getBuildings();
      if (!mounted) return;
      final appState = context.read<AppState>();
      // Sync server buildings into AppState (replace local list)
      for (final b in buildings) {
        if (!appState.buildings.any((e) => e.id == b.id)) {
          appState.addBuilding(b);
        }
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMsg = e.message);
    } catch (_) {
      // silently fall back to local cache
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBuildingScreen()),
          );
          _loadBuildings(); // refresh after add
        },
        backgroundColor: AppColors.primary500,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('مبنى جديد',
            style: AppTypography.button.copyWith(color: AppColors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMsg != null && buildings.isEmpty
              ? _ErrorState(message: _errorMsg!, onRetry: _loadBuildings)
              : buildings.isEmpty
                  ? _EmptyState(onAdd: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AddBuildingScreen()));
                      _loadBuildings();
                    })
                  : RefreshIndicator(
                      onRefresh: _loadBuildings,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: buildings.length,
                        itemBuilder: (_, i) => _BuildingCard(
                          building: buildings[i],
                          onTap: () => _goToScan(context, buildings[i].id),
                        ),
                      ),
                    ),
    );
  }

  void _goToScan(BuildContext context, String? buildingId) {
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: AppColors.grey300),
          const SizedBox(height: AppSpacing.md),
          Text('تعذّر تحميل المباني', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Text(message,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500),
          ),
        ],
      ),
    );
  }
}
