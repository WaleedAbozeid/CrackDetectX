/// Severity levels for detected cracks
enum Severity {
  low,
  medium,
  high,
}

/// Metrics from AI detection analysis
class DetectionMetrics {
  final double confidence;
  final Severity severity;
  final double lengthMeters;
  final double maxWidthMeters;

  /// Creates a DetectionMetrics instance
  /// 
  /// [confidence] - Confidence score (0.0-1.0)
  /// [severity] - Severity level of the crack
  /// [lengthMeters] - Length of the crack in meters (must be >= 0)
  /// [maxWidthMeters] - Maximum width of the crack in meters (must be >= 0)
  /// 
  /// Throws [ArgumentError] if values are invalid
  DetectionMetrics({
    required this.confidence,
    required this.severity,
    required this.lengthMeters,
    required this.maxWidthMeters,
  }) {
    _validate();
  }

  /// Validates the metrics values
  void _validate() {
    if (confidence < 0.0 || confidence > 1.0) {
      throw ArgumentError.value(
        confidence,
        'confidence',
        'Confidence must be between 0.0 and 1.0',
      );
    }
    if (lengthMeters < 0) {
      throw ArgumentError.value(
        lengthMeters,
        'lengthMeters',
        'Length must be non-negative',
      );
    }
    if (maxWidthMeters < 0) {
      throw ArgumentError.value(
        maxWidthMeters,
        'maxWidthMeters',
        'Max width must be non-negative',
      );
    }
  }

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

/// Mask data for detected crack overlay
class DetectionMask {
  final String base64Data;
  final String? overlayPath;

  /// Creates a DetectionMask instance
  /// 
  /// [base64Data] - Base64 encoded mask data
  /// [overlayPath] - Optional file path to overlay image
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

/// Complete detection result from AI processing
class DetectionResult {
  final String id;
  final DetectionMask mask;
  final DetectionMetrics metrics;
  final DateTime timestamp;

  /// Creates a DetectionResult instance
  /// 
  /// [id] - Unique identifier for the result (must be non-empty)
  /// [mask] - Detection mask with overlay data
  /// [metrics] - Detection metrics
  /// [timestamp] - When the detection was performed
  /// 
  /// Throws [ArgumentError] if id is empty
  DetectionResult({
    required this.id,
    required this.mask,
    required this.metrics,
    required this.timestamp,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'ID must be non-empty');
    }
  }

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

/// Report containing detection results and metadata
class Report {
  final String id;
  final String imagePath;
  final DetectionResult result;
  final DateTime createdAt;

  /// Creates a Report instance
  /// 
  /// [id] - Unique identifier for the report (must be non-empty)
  /// [imagePath] - File path of the analyzed image (must be non-empty)
  /// [result] - Detection result from AI processing
  /// [createdAt] - When the report was created
  /// 
  /// Throws [ArgumentError] if id or imagePath is empty
  Report({
    required this.id,
    required this.imagePath,
    required this.result,
    required this.createdAt,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'ID must be non-empty');
    }
    if (imagePath.trim().isEmpty) {
      throw ArgumentError.value(
        imagePath,
        'imagePath',
        'Image path must be non-empty',
      );
    }
  }

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
