import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/app_button.dart';
import '../widgets/card.dart';
import '../design/typography.dart';
import '../design/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'الرئيسية'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إجراءات سريعة', style: AppTypography.headline2),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: const [
                Expanded(child: AppButton(title: 'ابدأ فحص')),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: AppButton(title: 'التقارير')),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('التقارير الحديثة', style: AppTypography.headline3),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: ListTile(
                      title: Text('تقرير تجريبي #${i + 1}', style: AppTypography.bodyText1),
                      subtitle: Text('شدة: متوسطة', style: AppTypography.caption),
                      trailing: const Icon(Icons.chevron_left),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
