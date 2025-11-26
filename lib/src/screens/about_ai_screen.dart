import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/card.dart';

class AboutAIScreen extends StatelessWidget {
  const AboutAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'عن الذكاء الاصطناعي'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('التطبيق يستخدم نموذجاً تجريبياً لمعالجة الصور (STUB).', style: AppTypography.bodyText1))),
            const SizedBox(height: AppSpacing.md),
            Text('ملاحظات السلامة', style: AppTypography.headline3),
            const SizedBox(height: AppSpacing.sm),
            AppCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('- لا تعتمد على النتائج بدون مراجعة بشرية', style: AppTypography.bodyText2))),
          ],
        ),
      ),
    );
  }
}
