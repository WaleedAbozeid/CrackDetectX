import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/app_state.dart';
import '../ai/model_stub.dart';
import '../ai/types.dart';
import '../repositories/scan_repository.dart';
import '../models/scan_model.dart';
import '../core/api_exception.dart';
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

  /// Visual progress animation — runs in parallel with the backend call.
  Future<void> _runStatusAnimation() async {
    final stages = [
      (ScanStatus.queued,    500),
      (ScanStatus.analyzing, 1500),
      (ScanStatus.detecting, 1500),
      (ScanStatus.reporting, 1000),
    ];
    for (final (status, delay) in stages) {
      await Future.delayed(Duration(milliseconds: delay));
      if (mounted) setState(() => _currentStatus = status);
    }
  }

  Future<void> _runProcessing() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final imagePath  = appState.selectedImagePath;   // single (legacy)
    final buildingId = appState.selectedBuildingId;

    // Build the list — use multi-image list when available, otherwise wrap single
    final imagePaths = (imagePath != null && imagePath.isNotEmpty)
        ? [imagePath]
        : <String>[];

    try {
      DetectionResult result;

      if (!AppState.useMockData && imagePaths.isNotEmpty) {
        // ── Live backend path ──────────────────────────────────────────
        final ScanModel scan = await ScanRepository.instance.createScan(
          imagePaths: imagePaths,   // plural — required by Postman / 2 AI Models
          buildingId: buildingId,
        );
        final ScanModel completed = await ScanRepository.instance.pollUntilDone(
          scan.id,
          intervalSeconds: 3,
        );
        result = _toDetectionResult(completed);
      } else {
        // ── Demo / mock fallback (AppState.useMockData = true) ─────────
        await Future.delayed(const Duration(seconds: 4));
        result = await processImageStub(imagePath ?? '');
      }

      appState.setDetectionResult(result);
      if (!mounted) return;
      setState(() => _currentStatus = ScanStatus.done);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.dangerRed),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen(error: true)),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen(error: true)),
      );
    }
  }

  /// Converts [ScanModel] + [AiResultModel] → [DetectionResult]
  /// for backward compatibility with ResultScreen.
  DetectionResult _toDetectionResult(ScanModel scan) {
    final ai = scan.result;
    return DetectionResult(
      id: scan.id,
      mask: DetectionMask(
        base64Data: '',
        overlayPath: ai?.maskImageUrl,
      ),
      metrics: DetectionMetrics(
        confidence:    ai?.confidence ?? 0.0,
        severity:      _mapSeverity(ai?.severity ?? 'low'),
        lengthMeters:  (ai?.crackAreaPercent ?? 0.0) / 10,
        maxWidthMeters: 0.0,
      ),
      timestamp: scan.completedAt ?? DateTime.now(),
      healthScore: ai?.healthScore ?? 100,
    );
  }

  Severity _mapSeverity(String s) {
    switch (s) {
      case 'critical':
      case 'high':   return Severity.high;
      case 'medium': return Severity.medium;
      default:       return Severity.low;
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
                const Center(child: Text('No image selected')),

              const SizedBox(height: AppSpacing.xl),

              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _ScanStatusStepper(currentStatus: _currentStatus),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _statusLabel,
                      style: AppTypography.h3.copyWith(color: AppColors.primary900),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'يرجى الانتظار بينما يفحص الذكاء الاصطناعي الصورة.',
                      style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary),
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
          final stepIdx = i ~/ 2;
          final passed = stepIdx < _currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: passed ? AppColors.primary500 : AppColors.grey200,
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final step = _steps[stepIdx];
        final isDone   = stepIdx < _currentIndex;
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
                color: (isDone || isActive) ? AppColors.primary500 : AppColors.grey200,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, color: AppColors.white, size: 14)
                    : isActive
                        ? const SizedBox(
                            width: 12, height: 12,
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
                color: (isDone || isActive) ? AppColors.primary500 : AppColors.grey400,
                fontSize: 9,
              ),
            ),
          ],
        );
      }),
    );
  }
}
