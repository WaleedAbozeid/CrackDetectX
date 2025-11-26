import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/colors.dart';
import 'scan_screen.dart';
import 'reports_list_screen.dart';
import 'todo_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('CrackDetectX', style: AppTypography.headline1),
                const SizedBox(height: AppSpacing.sm),
                Text('تحليل الشروخ والمعاينة باستخدام الذكاء الاصطناعي', textAlign: TextAlign.center, style: AppTypography.bodyText2.copyWith(color: AppColors.neutral700)),
                const SizedBox(height: AppSpacing.lg),
                AppButton(title: 'ابدأ الفحص', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen()))),
                const SizedBox(height: AppSpacing.md),
                AppButton(title: 'التقارير السابقة', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsListScreen()))),
                const SizedBox(height: AppSpacing.md),
                AppButton(title: 'قائمة المهام', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TodoScreen()))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// placeholders removed; navigation now goes to real screens
