import 'package:flutter/material.dart';
import '../ai/types.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/card.dart';

class ReportViewScreen extends StatelessWidget {
  final Report report;
  const ReportViewScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'عرض التقرير'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('معرف: ${report.id}', style: AppTypography.bodyText1),
            const SizedBox(height: AppSpacing.sm),
            Text('الصورة:', style: AppTypography.bodyText2),
            const SizedBox(height: AppSpacing.xs),
            AppCard(child: Image.network(report.imagePath, fit: BoxFit.contain)),
            const SizedBox(height: AppSpacing.md),
            Text('نسبة التأكد: ${(report.result.metrics.confidence * 100).toStringAsFixed(1)}%', style: AppTypography.bodyText1),
            const SizedBox(height: AppSpacing.sm),
            Text('طول الشق التقريبي: ${report.result.metrics.lengthMeters.toStringAsFixed(2)} م', style: AppTypography.bodyText1),
            const SizedBox(height: AppSpacing.md),
            if (report.result.mask.overlayPath != null) AppCard(child: Image.network(report.result.mask.overlayPath!, fit: BoxFit.contain)),
          ],
        ),
      ),
    );
  }
}
