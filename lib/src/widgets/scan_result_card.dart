import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../design/spacing.dart';
import '../design/shadows.dart';
import 'risk_badge.dart';
import 'health_score_circle.dart';
import '../ai/types.dart';

/// Scan result card widget
/// Displays building image with health score and risk level
class ScanResultCard extends StatelessWidget {
  final String imagePath;
  final String? buildingName;
  final String? location;
  final double healthScore;
  final Severity riskLevel;
  final DateTime scanDate;
  final VoidCallback? onTap;

  const ScanResultCard({
    required this.imagePath,
    this.buildingName,
    this.location,
    required this.healthScore,
    required this.riskLevel,
    required this.scanDate,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: AppShadows.elevated,
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Building image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              child: Image.asset(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: AppColors.backgroundLight,
                    child: const Icon(Icons.image, size: 60, color: AppColors.grey400),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Building info
            if (buildingName != null) ...[
              Text(
                buildingName!,
                style: AppTypography.h3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            if (location != null) ...[
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    location!,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            
            // Health score and risk badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Health score circle (smaller version)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: HealthScoreCircle(
                    healthScore: healthScore,
                    size: 80,
                    strokeWidth: 8,
                  ),
                ),
                // Risk badge
                RiskBadge(severity: riskLevel),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Scan date
            Text(
              'Scanned: ${_formatDate(scanDate)}',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


