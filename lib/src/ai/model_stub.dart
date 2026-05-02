import 'dart:async';
import 'package:uuid/uuid.dart';
import 'types.dart';
import '../core/constants.dart';

/// UUID generator instance
final _uuid = Uuid();

/// Processes an image using a stub AI model (for development/testing)
///
/// Simulates the full scan pipeline:
/// queued → analyzing → detecting → reporting → done
///
/// [path] - File path of the image to process
/// Returns a [DetectionResult] with simulated metrics and healthScore
Future<DetectionResult> processImageStub(String path) async {
  try {
    // Simulate processing delay (1.5-3 seconds)
    final delayMs = AppConstants.minProcessingDelayMs +
        (DateTime.now().millisecondsSinceEpoch % 3) * 500;
    await Future.delayed(Duration(milliseconds: delayMs));

    // Generate simulated confidence (0.6-1.0)
    final randomFactor = DateTime.now().millisecondsSinceEpoch % 40;
    final confidence = AppConstants.minConfidence + (randomFactor / 100);
    final clampedConfidence = confidence.clamp(0.0, AppConstants.maxConfidence);

    final severity = _determineSeverity(clampedConfidence);
    final healthScore = _calculateHealthScore(severity, clampedConfidence);
    final metrics = _generateSimulatedMetrics(clampedConfidence);

    final mask = DetectionMask(
      base64Data: '',
      overlayPath: path,
    );

    return DetectionResult(
      id: _uuid.v4(),
      mask: mask,
      metrics: metrics,
      timestamp: DateTime.now(),
      healthScore: healthScore,
    );
  } catch (e) {
    throw Exception('${AppConstants.errorImageProcessingFailed}: $e');
  }
}

/// Determines severity level based on confidence score
Severity _determineSeverity(double confidence) {
  if (confidence >= AppConstants.highRiskThreshold) {
    return Severity.high;
  } else if (confidence >= AppConstants.mediumRiskThreshold) {
    return Severity.medium;
  } else {
    return Severity.low;
  }
}

/// Calculates building health score (0-100) based on severity and confidence
/// High severity → low health score | Low severity → high health score
int _calculateHealthScore(Severity severity, double confidence) {
  final seed = DateTime.now().millisecondsSinceEpoch % 20;
  return switch (severity) {
    Severity.high   => (20 + seed).clamp(0, 100),
    Severity.medium => (45 + seed).clamp(0, 100),
    Severity.low    => (72 + seed).clamp(0, 100),
  };
}

/// Generates simulated detection metrics
DetectionMetrics _generateSimulatedMetrics(double confidence) {
  final randomSeed = DateTime.now().millisecondsSinceEpoch;

  final lengthMeters = (0.2 + (randomSeed % 500) / 100).clamp(0.0, 5.0);
  final maxWidthMeters = (0.01 + (randomSeed % 20) / 1000).clamp(0.0, 0.1);

  return DetectionMetrics(
    confidence: confidence,
    severity: _determineSeverity(confidence),
    lengthMeters: double.parse(lengthMeters.toStringAsFixed(2)),
    maxWidthMeters: double.parse(maxWidthMeters.toStringAsFixed(3)),
  );
}
