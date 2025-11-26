import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../widgets/card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'الإعدادات'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اللغة', style: AppTypography.headline3),
            const SizedBox(height: AppSpacing.sm),
            AppCard(child: ListTile(title: Text('اللغة العربية'))),
            const SizedBox(height: AppSpacing.md),
            Text('خيارات', style: AppTypography.headline3),
            const SizedBox(height: AppSpacing.sm),
            AppCard(child: ListTile(title: Text('تحميل نتائج تلقائياً'))),
          ],
        ),
      ),
    );
  }
}
