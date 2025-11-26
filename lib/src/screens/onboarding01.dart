import 'package:flutter/material.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/app_button.dart';
import 'onboarding02.dart';

class Onboarding01 extends StatelessWidget {
  const Onboarding01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('مرحبا في CrackDetectX', style: AppTypography.headline1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            Text('التقاط صور للشروخ وتحليلها بسرعة', style: AppTypography.bodyText1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            AppButton(title: 'التالي', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Onboarding02()))),
          ],
        ),
      ),
    );
  }
}
