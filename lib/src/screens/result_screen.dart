import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../ai/types.dart';
import '../store/app_state.dart';
import '../widgets/app_button.dart';
import '../widgets/loader.dart';
import 'reports_list_screen.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../widgets/card.dart';
import '../services/pdf_service.dart';

class ResultScreen extends StatefulWidget {
  final bool error;
  const ResultScreen({super.key, this.error = false});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isGeneratingPDF = false;

  Future<void> _sharePDFReport(Report report) async {
    setState(() => _isGeneratingPDF = true);
    try {
      final pdfPath = await generateReportPDF(report);
      if (pdfPath != null && mounted) {
        await Share.shareXFiles([XFile(pdfPath)], text: 'تقرير كشف الشقوق');
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPDF = false);
    }
  }

  Future<void> _savePDFReport(BuildContext context, Report report) async {
    setState(() => _isGeneratingPDF = true);
    try {
      final pdfPath = await generateReportPDF(report);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pdfPath != null ? 'تم حفظ التقرير: $pdfPath' : 'فشل حفظ التقرير')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPDF = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final result = appState.detectionResult;

    if (_isGeneratingPDF) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Loader(),
              const SizedBox(height: AppSpacing.md),
              Text('جاري إنشاء التقرير...', style: AppTypography.bodyText1),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج التحليل', style: AppTypography.h3),
        backgroundColor: AppColors.primary500,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.error)
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.dangerRed, size: 24),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text('حدث خطأ أثناء المعالجة. يرجى المحاولة مجددًا.',
                              style: AppTypography.bodyText1.copyWith(color: AppColors.dangerRed)),
                        ),
                      ],
                    ),
                  ),
                )
              else if (result == null)
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text('لا توجد نتيجة متاحة', style: AppTypography.bodyText2),
                  ),
                )
              else ...[
                Text('ملخص النتيجة', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('نسبة التأكد', style: AppTypography.h4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: result.metrics.confidence > 0.8 ? AppColors.successGreen : AppColors.warningOrange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(result.metrics.confidence * 100).toStringAsFixed(1)}%',
                                style: AppTypography.button.copyWith(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text('طول الشق التقريبي', style: AppTypography.h4),
                        const SizedBox(height: AppSpacing.xs),
                        Text('${result.metrics.lengthMeters.toStringAsFixed(2)} متر',
                            style: AppTypography.bodyText1.copyWith(fontSize: 18)),
                        const SizedBox(height: AppSpacing.md),
                        Text('التوصيات', style: AppTypography.h4),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          result.metrics.confidence > 0.8
                              ? 'يُنصح بإجراء إصلاح فوري.'
                              : 'يُنصح بمراقبة الحالة والإصلاح عند الحاجة.',
                          style: AppTypography.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (result.mask.overlayPath != null) ...[
                  Text('خريطة التحليل', style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.sm),
                  AppCard(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(result.mask.overlayPath!, fit: BoxFit.cover, errorBuilder: (_, _, _) {
                        return Container(
                          height: 200,
                          color: AppColors.grey100,
                          child: Center(
                            child: Text('فشل تحميل الصورة', style: AppTypography.bodyText2),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
              ],
              if (result != null) ...[
                Text('الإجراءات', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('مشاركة'),
                        onPressed: () {
                          final report = Report(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            imagePath: appState.selectedImagePath ?? '',
                            result: result,
                            createdAt: DateTime.now(),
                          );
                          _sharePDFReport(report);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text('حفظ'),
                        onPressed: () {
                          final report = Report(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            imagePath: appState.selectedImagePath ?? '',
                            result: result,
                            createdAt: DateTime.now(),
                          );
                          Provider.of<AppState>(context, listen: false).addReport(report);
                          _savePDFReport(context, report);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حفظ التقرير بنجاح')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    title: 'عرض جميع التقارير',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportsListScreen()),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
