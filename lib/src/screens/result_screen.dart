import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ai/types.dart';
import '../store/app_state.dart';
import '../widgets/app_button.dart';
import 'reports_list_screen.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import '../widgets/card.dart';

class ResultScreen extends StatelessWidget {
  final bool error;
  const ResultScreen({super.key, this.error = false});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
  final result = appState.detectionResult;

    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(56), child: SizedBox()),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('النتيجة', style: AppTypography.headline2),
            const SizedBox(height: AppSpacing.sm),
            if (error) Text('حدث خطأ أثناء المعالجة', style: AppTypography.bodyText1.copyWith(color: AppColors.dangerRed)),
            if (result == null && !error) Text('لا توجد نتيجة متاحة', style: AppTypography.bodyText2),
            if (result != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text('نسبة التأكد: ${(result.metrics.confidence * 100).toStringAsFixed(1)}%', style: AppTypography.headline3),
              const SizedBox(height: AppSpacing.sm),
              Text('طول الشق التقريبي: ${result.metrics.lengthMeters.toStringAsFixed(2)} م', style: AppTypography.bodyText1),
              const SizedBox(height: AppSpacing.md),
              if (result.mask.overlayPath != null)
                AppCard(child: Image.network(result.mask.overlayPath!, fit: BoxFit.contain)),
            ],
            const Spacer(),
            Row(
              children: [
                Expanded(child: AppButton(title: 'حفظ التقرير', onPressed: () {
                  if (result != null) {
                    final report = Report(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      imagePath: appState.selectedImagePath ?? '',
                      result: result,
                      createdAt: DateTime.now(),
                    );
                    Provider.of<AppState>(context, listen: false).addReport(report);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsListScreen()));
                  }
                })),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: AppButton(title: 'قائمة التقارير', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsListScreen())))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
