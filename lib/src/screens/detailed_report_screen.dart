import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/top_bar.dart';
import '../widgets/card.dart';
import '../widgets/health_score_ring.dart';
import '../widgets/app_button.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';

class DetailedReportScreen extends StatelessWidget {
  const DetailedReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final healthScore = 78.0;
    final riskLevel = 'Moderate';
    final crackCount = 4;
    final avgWidth = '1.2 mm';
    final maxLength = '15 cm';

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: const AppTopBar(title: 'Detailed Analysis Report'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Overall Health Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey900.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    HealthScoreRing(score: healthScore),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.warningOrange),
                      ),
                      child: Text(
                        'Risk Level: $riskLevel',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.warningDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 2. Key Metrics Grid
              Text('Key Metrics', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Cracks Detected',
                      value: '$crackCount',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _MetricCard(title: 'Avg. Width', value: avgWidth),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _MetricCard(title: 'Max Length', value: maxLength),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // 3. Analysis Charts (Simulated with Bars)
              Text('Crack Depth Distribution', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: AppColors.successGreen,
                            value: 60,
                            title: '60%',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: AppColors.warningOrange,
                            value: 30,
                            title: '30%',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: AppColors.dangerRed,
                            value: 10,
                            title: '10%',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('< 1mm', AppColors.successGreen),
                  const SizedBox(width: AppSpacing.md),
                  _buildLegendItem('1-3mm', AppColors.warningOrange),
                  const SizedBox(width: AppSpacing.md),
                  _buildLegendItem('> 3mm', AppColors.dangerRed),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // 4. Recommendations
              Text('Recommendations', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _RecommendationItem(
                        icon: Icons.check_circle,
                        text: 'Monitor minor cracks every 3 months.',
                        color: AppColors.successGreen,
                      ),
                      const Divider(height: AppSpacing.xl),
                      _RecommendationItem(
                        icon: Icons.warning,
                        text: 'Consult a structural engineer for cracks > 2mm.',
                        color: AppColors.warningOrange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Export Button
              AppButton(
                title: 'Download PDF Report',
                prefixIcon: Icons.picture_as_pdf,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.h3.copyWith(color: AppColors.primary900),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

Widget _buildLegendItem(String title, Color color) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      const SizedBox(width: 4),
      Text(title, style: AppTypography.caption),
    ],
  );
}

class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _RecommendationItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    );
  }
}
