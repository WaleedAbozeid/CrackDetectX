import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/card.dart';

class DetailedReportScreen extends StatelessWidget {
  const DetailedReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'تقرير مفصل'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مخططات ومقاييس', style: AppTypography.headline2),
            const SizedBox(height: AppSpacing.sm),
            AppCard(child: SizedBox(height: 160, child: Center(child: Text('مخطط تجريبي (نحتاج تثبيت victory/flutter charts)', style: AppTypography.bodyText2)))),
            const SizedBox(height: AppSpacing.md),
            Text('التوصيات', style: AppTypography.headline3),
            const SizedBox(height: AppSpacing.sm),
            AppCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('- راجع مهندس إنشائي', style: AppTypography.bodyText1))),
          ],
        ),
      ),
    );
  }
}
