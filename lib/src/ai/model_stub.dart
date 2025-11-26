import 'dart:async';
import 'package:uuid/uuid.dart';
import 'types.dart';

final _uuid = Uuid();

Future<DetectionResult> processImageStub(String path) async {
  // simulate processing delay
  await Future.delayed(Duration(milliseconds: 1500 + (500 * (DateTime.now().millisecondsSinceEpoch % 3))));

  final confidence = (0.6 + (DateTime.now().millisecondsSinceEpoch % 40) / 100);
  final severity = confidence > 0.85 ? Severity.high : (confidence > 0.7 ? Severity.medium : Severity.low);

  final metrics = DetectionMetrics(
    confidence: confidence,
    severity: severity,
    lengthMeters: double.parse((0.2 + (DateTime.now().millisecondsSinceEpoch % 500) / 100).toStringAsFixed(2)),
    maxWidthMeters: double.parse((0.01 + (DateTime.now().millisecondsSinceEpoch % 20) / 1000).toStringAsFixed(3)),
  );

  final mask = DetectionMask(base64Data: '', overlayPath: path);

  return DetectionResult(id: _uuid.v4(), mask: mask, metrics: metrics, timestamp: DateTime.now());
}
