import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/radius.dart';
import '../design/spacing.dart';
import '../ai/types.dart';

/// Risk level badge widget
/// Displays a colored badge with risk level indicator
class RiskBadge extends StatelessWidget {
  final Severity severity;
  final String? customText;

  const RiskBadge({
    required this.severity,
    this.customText,
    super.key,
  });

  Color _getRiskColor() {
    switch (severity) {
      case Severity.high:
        return AppColors.highRisk;
      case Severity.medium:
        return AppColors.mediumRisk;
      case Severity.low:
        return AppColors.lowRisk;
    }
  }

  Color _getRiskBackgroundColor() {
    switch (severity) {
      case Severity.high:
        return AppColors.highRiskBackground;
      case Severity.medium:
        return AppColors.mediumRiskBackground;
      case Severity.low:
        return AppColors.lowRiskBackground;
    }
  }

  String _getRiskText() {
    if (customText != null) return customText!;
    switch (severity) {
      case Severity.high:
        return 'High Risk';
      case Severity.medium:
        return 'Medium Risk';
      case Severity.low:
        return 'Low Risk';
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor();
    final backgroundColor = _getRiskBackgroundColor();
    final riskText = _getRiskText();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: riskColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: riskColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            riskText,
            style: AppTypography.bodySmall.copyWith(
              color: riskColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
