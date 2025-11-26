enum Severity { low, medium, high }

class DetectionMetrics {
  final double confidence;
  final Severity severity;
  final double lengthMeters;
  final double maxWidthMeters;

  DetectionMetrics({
    required this.confidence,
    required this.severity,
    required this.lengthMeters,
    required this.maxWidthMeters,
  });

  Map<String, dynamic> toJson() {
    return {
      'confidence': confidence,
      'severity': severity.toString().split('.').last,
      'lengthMeters': lengthMeters,
      'maxWidthMeters': maxWidthMeters,
    };
  }

  factory DetectionMetrics.fromJson(Map<String, dynamic> json) {
    return DetectionMetrics(
      confidence: json['confidence'],
      severity: Severity.values.firstWhere(
        (e) => e.toString().split('.').last == json['severity'],
      ),
      lengthMeters: json['lengthMeters'],
      maxWidthMeters: json['maxWidthMeters'],
    );
  }
}

class DetectionMask {
  final String base64Data;
  final String? overlayPath;

  DetectionMask({
    required this.base64Data,
    this.overlayPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'base64Data': base64Data,
      'overlayPath': overlayPath,
    };
  }

  factory DetectionMask.fromJson(Map<String, dynamic> json) {
    return DetectionMask(
      base64Data: json['base64Data'],
      overlayPath: json['overlayPath'],
    );
  }
}

class DetectionResult {
  final String id;
  final DetectionMask mask;
  final DetectionMetrics metrics;
  final DateTime timestamp;

  DetectionResult({
    required this.id,
    required this.mask,
    required this.metrics,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mask': mask.toJson(),
      'metrics': metrics.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      id: json['id'],
      mask: DetectionMask.fromJson(json['mask']),
      metrics: DetectionMetrics.fromJson(json['metrics']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class Report {
  final String id;
  final String imagePath;
  final DetectionResult result;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.imagePath,
    required this.result,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'result': result.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      imagePath: json['imagePath'],
      result: DetectionResult.fromJson(json['result']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
