import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';

/// Health score circle widget with circular progress indicator
/// Displays health score (0-100) with color-coded progress
class HealthScoreCircle extends StatelessWidget {
  final double healthScore; // 0-100
  final double size;
  final double strokeWidth;

  const HealthScoreCircle({
    required this.healthScore,
    this.size = 120.0,
    this.strokeWidth = 12.0,
    super.key,
  }) : assert(healthScore >= 0 && healthScore <= 100, 'Health score must be between 0 and 100');

  Color _getScoreColor() {
    if (healthScore >= 80) {
      return AppColors.lowRisk; // Green
    } else if (healthScore >= 60) {
      return AppColors.mediumRisk; // Orange
    } else {
      return AppColors.highRisk; // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor();
    final progress = healthScore / 100;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: AppColors.backgroundLight,
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              healthScore.toInt().toString(),
              style: AppTypography.h1.copyWith(
                color: AppColors.primaryDark,
                fontSize: 32,
              ),
            ),
            Text(
              'Health Score',
              style: AppTypography.caption,
            ),
          ],
        ),
      ],
    );
  }
}


