import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../ai/types.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../widgets/card.dart';
import '../services/pdf_service.dart';

class ReportViewScreen extends StatefulWidget {
  final Report report;
  const ReportViewScreen({super.key, required this.report});

  @override
  State<ReportViewScreen> createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends State<ReportViewScreen> {
  bool _isSharing = false;

  Future<void> _shareReport() async {
    setState(() => _isSharing = true);
    try {
      final pdfPath = await generateReportPDF(widget.report);
      if (pdfPath != null && mounted) {
        await Share.shareXFiles([XFile(pdfPath)], text: 'تقرير كشف الشقوق');
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    return Scaffold(
      appBar: const AppTopBar(title: 'عرض التقرير'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Header
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('معرّف التقرير', style: AppTypography.caption),
                              const SizedBox(height: AppSpacing.xs),
                              Text(report.id.substring(0, 16), style: AppTypography.h4),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: report.result.metrics.confidence > 0.8
                                  ? AppColors.successGreen.withValues(alpha: 0.1)
                                  : AppColors.warningOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(report.result.metrics.confidence * 100).toStringAsFixed(1)}%',
                              style: AppTypography.button.copyWith(
                                color: report.result.metrics.confidence > 0.8
                                    ? AppColors.successGreen
                                    : AppColors.warningOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('التاريخ والوقت', style: AppTypography.caption),
                              const SizedBox(height: AppSpacing.xs),
                              Text(report.createdAt.toLocal().toString().split('.')[0], style: AppTypography.bodyText1),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('طول الشق', style: AppTypography.caption),
                              const SizedBox(height: AppSpacing.xs),
                              Text('${report.result.metrics.lengthMeters.toStringAsFixed(2)} م', style: AppTypography.bodyText1),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Image Section
              Text('الصورة الأصلية', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    report.imagePath,
                    fit: BoxFit.cover,
                    height: 250,
                    errorBuilder: (_, _, _) => Container(
                      height: 250,
                      color: AppColors.grey100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image_outlined, color: AppColors.grey400, size: 48),
                            const SizedBox(height: AppSpacing.sm),
                            Text('لم تتمكن من تحميل الصورة', style: AppTypography.bodyText2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Analysis Results
              Text('نتائج التحليل', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      _buildMetricRow(
                        'نسبة التأكد',
                        '${(report.result.metrics.confidence * 100).toStringAsFixed(1)}%',
                        Colors.blue,
                      ),
                      const Divider(height: 16),
                      _buildMetricRow(
                        'طول الشق التقريبي',
                        '${report.result.metrics.lengthMeters.toStringAsFixed(2)} متر',
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Overlay Map
              if (report.result.mask.overlayPath != null) ...[
                Text('خريطة التحليل', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      report.result.mask.overlayPath!,
                      fit: BoxFit.cover,
                      height: 250,
                      errorBuilder: (_, _, _) => Container(
                        height: 250,
                        color: AppColors.grey100,
                        child: Center(
                          child: Text('فشل تحميل الخريطة', style: AppTypography.bodyText2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Recommendations
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('التوصيات', style: AppTypography.h4),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        report.result.metrics.confidence > 0.8
                            ? '⚠️ يُنصح بإجراء إصلاح فوري للشق المكتشف.'
                            : '✓ يُنصح بمراقبة الحالة والإصلاح عند الحاجة.',
                        style: AppTypography.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Share Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSharing ? null : _shareReport,
                  icon: const Icon(Icons.share),
                  label: Text(_isSharing ? 'جاري المشاركة...' : 'مشاركة التقرير'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    backgroundColor: AppColors.primary500,
                    disabledBackgroundColor: AppColors.grey300,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              color: color,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
            ),
            Text(label, style: AppTypography.bodyText1),
          ],
        ),
        Text(value, style: AppTypography.h4),
      ],
    );
  }
}
