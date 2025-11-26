import 'package:flutter/material.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/app_button.dart';
import 'onboarding03.dart';

class Onboarding02 extends StatelessWidget {
  const Onboarding02({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('التعليمات', style: AppTypography.headline2, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            Text('التقط الصورة من زاوية جيدة وضمن الإضاءة المناسبة', style: AppTypography.bodyText1, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            AppButton(title: 'التالي', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Onboarding03()))),
          ],
        ),
      ),
    );
  }
}
