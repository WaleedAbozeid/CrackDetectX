import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../ai/model_stub.dart';
import '../ai/types.dart';
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
  ScanStatus _currentStatus = ScanStatus.queued;

  // Maps each status to its display label
  String get _statusLabel => switch (_currentStatus) {
        ScanStatus.queued    => 'في انتظار المعالجة...',
        ScanStatus.analyzing => 'جاري تحليل الصورة...',
        ScanStatus.detecting => 'جاري كشف الشقوق...',
        ScanStatus.reporting => 'جاري إنشاء التقرير...',
        ScanStatus.done      => 'اكتمل التحليل ✓',
        _                    => 'جاري المعالجة...',
      };

  @override
  void initState() {
    super.initState();
    _runProcessing();
    _runStatusAnimation();
  }

  /// Animated status progression matching the backend's real stages
  Future<void> _runStatusAnimation() async {
    final stages = [
      (ScanStatus.queued,    500),
      (ScanStatus.analyzing, 1200),
      (ScanStatus.detecting, 1200),
      (ScanStatus.reporting, 800),
    ];
    for (final (status, delay) in stages) {
      await Future.delayed(Duration(milliseconds: delay));
      if (mounted) setState(() => _currentStatus = status);
    }
  }

  Future<void> _runProcessing() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final img = appState.selectedImagePath;
    try {
      await Future.delayed(const Duration(seconds: 4));
      final result = await processImageStub(img ?? '');
      appState.setDetectionResult(result);
      if (!mounted) return;
      setState(() => _currentStatus = ScanStatus.done);
      await Future.delayed(const Duration(milliseconds: 400));
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
              // Image with scanner overlay
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
                const Center(child: Text('No image selected')),

              const SizedBox(height: AppSpacing.xl),

              // Status pipeline indicator
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _ScanStatusStepper(currentStatus: _currentStatus),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _statusLabel,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.primary900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'يرجى الانتظار بينما يفحص الذكاء الاصطناعي الصورة.',
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

/// Visual step indicator for the scan pipeline
class _ScanStatusStepper extends StatelessWidget {
  final ScanStatus currentStatus;

  const _ScanStatusStepper({required this.currentStatus});

  static const _steps = [
    (status: ScanStatus.queued,    label: 'انتظار'),
    (status: ScanStatus.analyzing, label: 'تحليل'),
    (status: ScanStatus.detecting, label: 'كشف'),
    (status: ScanStatus.reporting, label: 'تقرير'),
    (status: ScanStatus.done,      label: 'مكتمل'),
  ];

  int get _currentIndex =>
      _steps.indexWhere((s) => s.status == currentStatus);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final stepIdx = i ~/ 2;
          final passed = stepIdx < _currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: passed ? AppColors.primary500 : AppColors.grey200,
            ),
          );
        }
        // Step circle
        final stepIdx = i ~/ 2;
        final step = _steps[stepIdx];
        final isDone = stepIdx < _currentIndex;
        final isActive = stepIdx == _currentIndex;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? AppColors.primary500
                    : isActive
                        ? AppColors.primary500
                        : AppColors.grey200,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, color: AppColors.white, size: 14)
                    : isActive
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              step.label,
              style: AppTypography.caption.copyWith(
                color: (isDone || isActive)
                    ? AppColors.primary500
                    : AppColors.grey400,
                fontSize: 9,
              ),
            ),
          ],
        );
      }),
    );
  }
}
