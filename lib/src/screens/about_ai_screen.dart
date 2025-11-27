import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../design/radius.dart';

class AboutAIScreen extends StatelessWidget {
  const AboutAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppTopBar(
        title: 'About AI Model',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Hero Section
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary900,
                      AppColors.primary500,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'AI Detection Model',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primary900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Advanced neural networks for structural analysis',
                style: AppTypography.bodyText.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Model Architecture
              _InfoCard(
                title: 'Model Architecture',
                content: [
                  'U-Net for semantic segmentation',
                  'ResNet-50 backbone',
                  'YOLOv8 for object detection',
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Performance Metrics
              Text(
                'Performance Metrics',
                style: AppTypography.h3,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildMetricsGrid(),
              const SizedBox(height: AppSpacing.xxl),

              // Training Details
              _InfoCard(
                title: 'Training Details',
                content: [
                  'Dataset size: 50,000+ images',
                  'Crack types: Hairline, Medium, Severe, Structural',
                  'Last updated: November 2024',
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // How It Works
              _ExpandableSection(
                title: 'How It Works',
                steps: [
                  'Image preprocessing',
                  'Feature extraction',
                  'Crack detection',
                  'Severity analysis',
                  'Report generation',
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Limitations Notice
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(color: AppColors.warningOrange),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: AppColors.warningOrange,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Important Notice',
                            style: AppTypography.h4.copyWith(
                              color: AppColors.warningDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'AI assistance, not replacement for professionals\n\nAlways consult licensed engineers for critical decisions',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.2,
      children: const [
        _MetricCard(label: 'Accuracy', value: '96.8%'),
        _MetricCard(label: 'Confidence', value: '94.2%'),
        _MetricCard(label: 'Speed', value: '2.3s'),
        _MetricCard(label: 'Precision', value: '95.4%'),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({
    required this.label,
    required this.value,
  });

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: AppColors.primary900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> content;

  const _InfoCard({
    required this.title,
    required this.content,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h4.copyWith(
              color: AppColors.primary900,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...content.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.successGreen,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _ExpandableSection extends StatefulWidget {
  final String title;
  final List<String> steps;

  const _ExpandableSection({
    required this.title,
    required this.steps,
  });

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title, style: AppTypography.h4),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primary900,
            ),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                children: widget.steps
                    .asMap()
                    .entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.primary100,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.primary900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: AppTypography.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
