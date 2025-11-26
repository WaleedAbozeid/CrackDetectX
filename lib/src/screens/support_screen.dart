import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'الدعم'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اتصل بنا', style: AppTypography.headline2),
            const SizedBox(height: AppSpacing.sm),
            AppCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('البريد: support@crackdetectx.example', style: AppTypography.bodyText1))),
            const SizedBox(height: AppSpacing.md),
            AppCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('هاتف: +1 234 567 890', style: AppTypography.bodyText1))),
          ],
        ),
      ),
    );
  }
}
