/// Severity levels for detected cracks
enum Severity {
  low,
  medium,
  high,
}

/// Scan processing status — mirrors the backend's scan status field
enum ScanStatus {
  queued,    // في انتظار المعالجة
  analyzing, // جاري التحليل
  detecting, // جاري الكشف عن الشقوق
  reporting, // جاري إنشاء التقرير
  done,      // مكتمل
  failed,    // فشل
  cancelled, // ملغي
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
      confidence: (json['confidence'] as num).toDouble(),
      severity: Severity.values.firstWhere(
        (e) => e.toString().split('.').last == json['severity'],
        orElse: () => Severity.low,
      ),
      lengthMeters: (json['lengthMeters'] as num).toDouble(),
      maxWidthMeters: (json['maxWidthMeters'] as num).toDouble(),
    );
  }
}

/// Mask data for detected crack overlay
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
      base64Data: json['base64Data'] as String? ?? '',
      overlayPath: json['overlayPath'] as String?,
    );
  }
}

/// Complete detection result from AI processing
class DetectionResult {
  final String id;
  final DetectionMask mask;
  final DetectionMetrics metrics;
  final DateTime timestamp;

  /// مؤشر صحة المبنى (0-100) — كلما ارتفع كان المبنى في حالة أفضل
  final int healthScore;

  DetectionResult({
    required this.id,
    required this.mask,
    required this.metrics,
    required this.timestamp,
    this.healthScore = 100,
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
      'healthScore': healthScore,
    };
  }

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      id: json['id'] as String,
      mask: DetectionMask.fromJson(json['mask'] as Map<String, dynamic>),
      metrics: DetectionMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      healthScore: json['healthScore'] as int? ?? 100,
    );
  }
}

/// Report containing detection results and metadata
class Report {
  final String id;
  final String imagePath;
  final DetectionResult result;
  final DateTime createdAt;
  final String? buildingId;   // مرتبط بمبنى معين (optional — backward compat)
  final String? notes;         // ملاحظات المهندس
  final ScanStatus scanStatus; // حالة الفحص

  Report({
    required this.id,
    required this.imagePath,
    required this.result,
    required this.createdAt,
    this.buildingId,
    this.notes,
    this.scanStatus = ScanStatus.done,
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
      'buildingId': buildingId,
      'notes': notes,
      'scanStatus': scanStatus.toString().split('.').last,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      result: DetectionResult.fromJson(json['result'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      buildingId: json['buildingId'] as String?,
      notes: json['notes'] as String?,
      scanStatus: ScanStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['scanStatus'] as String?),
        orElse: () => ScanStatus.done,
      ),
    );
  }
}
