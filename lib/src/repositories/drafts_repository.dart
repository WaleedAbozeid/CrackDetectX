import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/offline_models.dart';

/// Repository for offline draft sync operations.
///
/// Implements the "Offline Sync" node (7.0) from the DFD Level 1 diagram.
///
/// Endpoints used (from Postman collection):
/// - `POST   /drafts`          — save a draft to the server
/// - `GET    /drafts`          — list all user drafts from server
/// - `DELETE /drafts/{id}`     — delete a draft
/// - `GET    /drafts/pending`  — fetch pending (unsynced) drafts
class DraftsRepository {
  DraftsRepository._();
  static final DraftsRepository instance = DraftsRepository._();

  final ApiClient _client = ApiClient.instance;

  // ─── POST /drafts ─────────────────────────────────────────────────────

  /// Saves a draft to the server.
  ///
  /// [draft] — the locally created [OfflineDraft] to push.
  /// Returns the server-synced version of the draft.
  Future<OfflineDraft> saveDraft(OfflineDraft draft) async {
    try {
      final response = await _client.post('/drafts', data: draft.toJson());
      return OfflineDraft.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /drafts ──────────────────────────────────────────────────────

  /// Lists all drafts for the current user stored on the server.
  Future<List<OfflineDraft>> getDrafts() async {
    try {
      final response = await _client.get('/drafts');
      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['drafts'] ?? []) as List<dynamic>;

      return list
          .map((e) => OfflineDraft.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── DELETE /drafts/{id} ──────────────────────────────────────────────

  /// Deletes a draft from the server.
  Future<void> deleteDraft(String draftId) async {
    try {
      await _client.delete('/drafts/$draftId');
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /drafts/pending ──────────────────────────────────────────────

  /// Fetches all pending (not yet synced) drafts from the server.
  ///
  /// Used by the offline sync flow: when internet is restored, call this
  /// to get any unsynced drafts and process them.
  Future<List<OfflineDraft>> getPendingDrafts() async {
    try {
      final response = await _client.get('/drafts/pending');
      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['drafts'] ?? []) as List<dynamic>;

      return list
          .map((e) => OfflineDraft.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Bulk Sync ────────────────────────────────────────────────────────

  /// Syncs all locally-stored pending drafts to the server in sequence.
  ///
  /// [localDrafts] — the list from local storage / AppState.
  /// Returns a map of draftId → success/failure.
  Future<Map<String, bool>> syncAll(List<OfflineDraft> localDrafts) async {
    final results = <String, bool>{};
    for (final draft in localDrafts) {
      if (draft.status == OfflineDraftStatus.pendingSync) {
        try {
          await saveDraft(draft);
          results[draft.id] = true;
        } catch (_) {
          results[draft.id] = false;
        }
      }
    }
    return results;
  }
}
