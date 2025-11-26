import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import 'image_review_screen.dart';
import 'ai_processing_screen.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../design/spacing.dart';
import '../widgets/top_bar.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  void _pickMockImage(BuildContext context) {
    // For scaffold: use a placeholder URI
    final path = 'https://via.placeholder.com/800x600.png?text=crack';
    Provider.of<AppState>(context, listen: false).setSelectedImage(path);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ImageReviewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'اختيار صورة'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppButton(title: 'اختر من المعرض (تجريبي)', onPressed: () => _pickMockImage(context)),
            const SizedBox(height: AppSpacing.sm),
            AppButton(title: 'تحليل بواسطة الذكاء الاصطناعي', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIProcessingScreen()))),
          ],
        ),
      ),
    );
  }
}
