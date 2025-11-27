import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../widgets/app_button.dart';
import 'ai_processing_screen.dart';
import '../widgets/top_bar.dart';
import '../design/spacing.dart';
import '../widgets/card.dart';
import '../design/typography.dart';
import '../design/colors.dart';

class ImageReviewScreen extends StatelessWidget {
  const ImageReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final image = appState.selectedImagePath;

    return Scaffold(
      appBar: const AppTopBar(title: 'مراجعة الصورة'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            if (image != null)
              Expanded(
                child: AppCard(
                  child: Center(child: Image.network(image, fit: BoxFit.contain)),
                ),
              )
            else
              AppCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('لا توجد صورة محددة', style: AppTypography.bodyText2.copyWith(color: AppColors.grey600)))),
            const SizedBox(height: AppSpacing.md),
            AppButton(title: 'تحليل الصورة', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIProcessingScreen()))),
          ],
        ),
      ),
    );
  }
}
