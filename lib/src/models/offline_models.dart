import 'package:flutter/foundation.dart';

import 'marketplace_models.dart';

enum OfflineDraftStatus {
  pendingSync,
  synced,
  failed,
}

@immutable
class OfflineDraft {
  final String id;
  final RepairRequest request;
  final OfflineDraftStatus status;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const OfflineDraft({
    required this.id,
    required this.request,
    this.status = OfflineDraftStatus.pendingSync,
    required this.createdAt,
    this.syncedAt,
  });

  OfflineDraft copyWith({
    OfflineDraftStatus? status,
    DateTime? syncedAt,
    RepairRequest? request,
  }) {
    return OfflineDraft(
      id: id,
      request: request ?? this.request,
      status: status ?? this.status,
      createdAt: createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request': request.toJson(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory OfflineDraft.fromJson(Map<String, dynamic> json) {
    return OfflineDraft(
      id: json['id'] as String,
      request: RepairRequest.fromJson(json['request'] as Map<String, dynamic>),
      status: OfflineDraftStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OfflineDraftStatus.pendingSync,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncedAt: json['syncedAt'] != null ? DateTime.parse(json['syncedAt'] as String) : null,
    );
  }
}

