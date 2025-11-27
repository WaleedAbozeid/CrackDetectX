import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';
import 'scan_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary900.withAlpha((0.05 * 255).toInt()),
              AppColors.primary500.withAlpha((0.03 * 255).toInt()),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                children: [
                  // App Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary900,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary900.withAlpha((0.3 * 255).toInt()),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.apartment,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // App Name
                  Text(
                    'CrackDetectX',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.primary900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Tagline
                  Text(
                    'AI-Powered Building Safety Inspector',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.grey600,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Feature Cards
                  _FeatureCard(
                    icon: Icons.scanner,
                    title: 'AI-Powered Detection',
                    description: 'Advanced neural networks analyze structural damage',
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _FeatureCard(
                    icon: Icons.warning_amber,
                    title: 'Real-Time Risk Analysis',
                    description: 'Instant assessment of crack severity levels',
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _FeatureCard(
                    icon: Icons.description,
                    title: 'Detailed Reports',
                    description: 'Comprehensive PDF reports with recommendations',
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Start Button
                  AppButton(
                    title: 'Start Inspection',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScanScreen(),
                      ),
                    ),
                    height: 56,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(
          color: AppColors.grey200,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey900.withAlpha((0.05 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary900,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h4,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
