import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/typography.dart';

class HealthScoreRing extends StatelessWidget {
  final double score; // 0 to 100
  final double size;
  final double strokeWidth;

  const HealthScoreRing({
    super.key,
    required this.score,
    this.size = 160,
    this.strokeWidth = 16,
  });

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 50) return AppColors.warningOrange;
    return AppColors.dangerRed;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              color: AppColors.grey100,
            ),
          ),
          // Progress Circle
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: score / 100),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  color: color,
                  strokeCap: StrokeCap.round,
                );
              },
            ),
          ),
          // Text Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toInt().toString(),
                style: AppTypography.h1.copyWith(
                  fontSize: 48,
                  color: AppColors.primary900,
                ),
              ),
              Text('Health Score', style: AppTypography.caption),
            ],
          ),
        ],
      ),
    );
  }
}
