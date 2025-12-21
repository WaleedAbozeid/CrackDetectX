import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../ai/model_stub.dart';
import 'result_screen.dart';
import '../widgets/top_bar.dart';
import '../widgets/scanner_overlay.dart';
import '../design/typography.dart';
import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/radius.dart';

class AIProcessingScreen extends StatefulWidget {
  const AIProcessingScreen({super.key});

  @override
  State<AIProcessingScreen> createState() => _AIProcessingScreenState();
}

class _AIProcessingScreenState extends State<AIProcessingScreen> {
  String _statusMessage = 'Analyzing structure...';

  @override
  void initState() {
    super.initState();
    _runProcessing();
    _startStatusUpdates();
  }

  void _startStatusUpdates() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _statusMessage = 'Detecting cracks...');
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _statusMessage = 'Assessing risk levels...');
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _statusMessage = 'Generating report...');
  }

  Future<void> _runProcessing() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final img = appState.selectedImagePath;
    try {
      // Small delay to ensure animation starts and looks good
      await Future.delayed(
        const Duration(seconds: 4),
      ); // Match the status updates roughly

      final result = await processImageStub(img ?? '');
      appState.setDetectionResult(result);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen(error: true)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = Provider.of<AppState>(context).selectedImagePath;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppTopBar(title: 'AI Analysis', showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null)
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey900.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      child: ScannerOverlay(
                        isScanning: true,
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const Center(child: Text("No image selected")),

              const SizedBox(height: AppSpacing.xl),

              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.primary500,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      _statusMessage,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.primary900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Please wait while our AI inspects your building.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
