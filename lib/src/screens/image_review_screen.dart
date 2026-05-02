import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../widgets/app_button.dart';
import 'ai_processing_screen.dart';
import '../widgets/top_bar.dart';
import '../design/spacing.dart';
import '../widgets/card.dart';

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
            Expanded(
              child: AppCard(
                child: Center(
                  child: (image != null && image.isNotEmpty)
                      ? (image.startsWith('http') ? Image.network(image, fit: BoxFit.contain) : Image.file(File(image), fit: BoxFit.contain))
                      : Image.asset('assets/images/imagetest(1)(1).jpg', fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(title: 'تحليل الصورة', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIProcessingScreen()))),
          ],
        ),
      ),
    );
  }
}
