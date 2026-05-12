/// Represents a scan job submitted to the backend for crack detection.
///
/// Maps to `POST /scans` response and `GET /scans/{id}`.
///
/// Backend statuses: `queued` → `processing` → `completed` | `failed`
class ScanModel {
  final String id;
  final String userId;
  final String? buildingId;

  /// Backend processing status string: queued | processing | completed | failed
  final String status;

  /// URL to the uploaded image (set after upload completes)
  final String? imageUrl;

  /// Local file path (only used before upload, never stored on server)
  final String? localImagePath;

  /// AI result — populated when status = `completed`
  final AiResultModel? result;

  /// Error message if status = `failed`
  final String? errorMessage;

  final DateTime createdAt;
  final DateTime? completedAt;

  const ScanModel({
    required this.id,
    required this.userId,
    this.buildingId,
    required this.status,
    this.imageUrl,
    this.localImagePath,
    this.result,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
  });

  // ─── Convenience status getters ───────────────────────────────────────

  bool get isCompleted  => status == 'completed';
  bool get isFailed     => status == 'failed';
  bool get isProcessing => status == 'queued' || status == 'processing';

  String get statusDisplay {
    switch (status) {
      case 'queued':     return 'In Queue';
      case 'processing': return 'Processing…';
      case 'completed':  return 'Completed';
      case 'failed':     return 'Failed';
      default:           return status;
    }
  }

  // ─── JSON ──────────────────────────────────────────────────────────────

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    return ScanModel(
      id:             (data['id'] ?? data['scan_id'] ?? '').toString(),
      userId:         (data['user_id'] ?? data['userId'] ?? '').toString(),
      buildingId:     data['building_id']?.toString() ?? data['buildingId']?.toString(),
      status:         (data['status'] ?? 'queued').toString(),
      imageUrl:       data['image_url']?.toString() ?? data['imageUrl']?.toString(),
      result:         data['result'] != null
          ? AiResultModel.fromJson(data['result'] as Map<String, dynamic>)
          : null,
      errorMessage:   data['error_message']?.toString() ?? data['errorMessage']?.toString(),
      createdAt:      data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      completedAt:    data['completed_at'] != null
          ? DateTime.tryParse(data['completed_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        if (buildingId != null) 'building_id': buildingId,
        'status': status,
        if (imageUrl != null) 'image_url': imageUrl,
        if (result != null) 'result': result!.toJson(),
        if (errorMessage != null) 'error_message': errorMessage,
        'created_at': createdAt.toIso8601String(),
        if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
      };

  ScanModel copyWith({
    String? status,
    AiResultModel? result,
    String? errorMessage,
    DateTime? completedAt,
  }) {
    return ScanModel(
      id:             id,
      userId:         userId,
      buildingId:     buildingId,
      status:         status ?? this.status,
      imageUrl:       imageUrl,
      localImagePath: localImagePath,
      result:         result ?? this.result,
      errorMessage:   errorMessage ?? this.errorMessage,
      createdAt:      createdAt,
      completedAt:    completedAt ?? this.completedAt,
    );
  }
}

// ─── AiResultModel ────────────────────────────────────────────────────────────

/// AI detection result embedded in a completed [ScanModel].
/// This is the richer backend model — separate from [DetectionResult] in types.dart.
class AiResultModel {
  /// Overall crack severity: `none` | `low` | `medium` | `high` | `critical`
  final String severity;

  /// Confidence score 0.0–1.0
  final double confidence;

  /// Crack coverage percentage of the image area
  final double crackAreaPercent;

  /// Detected crack types e.g. ['structural', 'hairline']
  final List<String> crackTypes;

  /// URL to the annotated/masked output image
  final String? maskImageUrl;

  /// Structured recommendations from the AI
  final List<String> recommendations;

  const AiResultModel({
    required this.severity,
    required this.confidence,
    required this.crackAreaPercent,
    required this.crackTypes,
    this.maskImageUrl,
    required this.recommendations,
  });

  factory AiResultModel.fromJson(Map<String, dynamic> json) {
    return AiResultModel(
      severity:         (json['severity'] ?? 'low').toString(),
      confidence:       (json['confidence'] as num?)?.toDouble() ?? 0.0,
      crackAreaPercent: ((json['crack_area_percent'] ?? json['crackAreaPercent']) as num?)
              ?.toDouble() ??
          0.0,
      crackTypes: (json['crack_types'] ?? json['crackTypes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      maskImageUrl:    json['mask_image_url']?.toString() ?? json['maskImageUrl']?.toString(),
      recommendations: (json['recommendations'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'severity': severity,
        'confidence': confidence,
        'crack_area_percent': crackAreaPercent,
        'crack_types': crackTypes,
        if (maskImageUrl != null) 'mask_image_url': maskImageUrl,
        'recommendations': recommendations,
      };

  // ─── Computed ─────────────────────────────────────────────────────────

  /// Health score 0–100
  int get healthScore {
    final base = ((1.0 - crackAreaPercent / 100.0) * confidence * 100).round();
    return base.clamp(0, 100);
  }

  bool get isCritical => severity == 'critical' || severity == 'high';
}
