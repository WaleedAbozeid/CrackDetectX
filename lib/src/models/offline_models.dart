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
}

