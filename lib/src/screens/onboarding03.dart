import 'package:flutter/material.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/app_button.dart';

class Onboarding03 extends StatelessWidget {
  const Onboarding03({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('جاهز للبدء', style: AppTypography.headline1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            Text('ابدأ الآن بفحص أول صورة', style: AppTypography.bodyText1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            AppButton(title: 'ابدأ الفحص', onPressed: () => Navigator.popUntil(context, (route) => route.isFirst)),
          ],
        ),
      ),
    );
  }
}
