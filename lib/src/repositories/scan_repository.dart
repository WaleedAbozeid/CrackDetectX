import 'dart:io';
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/scan_model.dart';

/// Repository for Scan operations — upload, status polling, and retrieval.
///
/// Endpoints used:
/// - `POST /scans`              — upload image + create scan job
/// - `GET  /scans/{id}`         — get scan with result
/// - `GET  /scans/{id}/status`  — lightweight status poll
/// - `GET  /scans`              — list user's scans
class ScanRepository {
  ScanRepository._();
  static final ScanRepository instance = ScanRepository._();

  final ApiClient _client = ApiClient.instance;

  // ─── POST /scans ───────────────────────────────────────────────────────

  /// Uploads one or more images and creates a new scan job.
  ///
  /// The backend supports **2 AI models** — pass multiple images for richer analysis.
  /// Returns a [ScanModel] with status = `queued`.
  /// Poll [pollUntilDone] until `completed` or `failed`.
  ///
  /// [imagePaths] — list of local file paths (min 1)
  /// [buildingId] — optional building FK
  /// [notes]      — optional notes attached to the scan
  Future<ScanModel> createScan({
    required List<String> imagePaths,
    String? buildingId,
    String? notes,
  }) async {
    try {
      // Build multipart list of images — key must be `images` (plural)
      final imageFiles = await Future.wait(
        imagePaths.map((path) async {
          final file = File(path);
          final fileName = file.path.split(Platform.pathSeparator).last;
          return await MultipartFile.fromFile(path, filename: fileName);
        }),
      );

      final formMap = <String, dynamic>{
        'images': imageFiles,
      };
      if (buildingId != null && buildingId.isNotEmpty) {
        formMap['building_id'] = buildingId;
      }
      if (notes != null && notes.isNotEmpty) {
        formMap['notes'] = notes;
      }

      final formData = FormData.fromMap(formMap);

      final response = await _client.post(
        '/scans',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(seconds: 120),
        ),
      );

      final data = (response.data['data'] ?? response.data) as Map<String, dynamic>;
      // Backend may wrap inside `scan` key
      final scanMap = data['scan'] as Map<String, dynamic>? ?? data;
      return ScanModel.fromJson(scanMap);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /scans/{id} ──────────────────────────────────────────────────

  /// Returns the full scan including AI result (when completed).
  Future<ScanModel> getScanById(String scanId) async {
    try {
      final response = await _client.get('/scans/$scanId');
      final data = (response.data['data'] ?? response.data) as Map<String, dynamic>;
      return ScanModel.fromJson(data);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /scans/{id}/status ───────────────────────────────────────────

  /// Lightweight status check — returns only the current status string.
  ///
  /// Values: `queued` | `processing` | `completed` | `failed`
  Future<String> getScanStatus(String scanId) async {
    try {
      final response = await _client.get('/scans/$scanId/status');
      final raw = response.data;
      return (raw is Map
              ? (raw['data']?['status'] ?? raw['status'])
              : raw)
          ?.toString() ??
          'queued';
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Polling helper ───────────────────────────────────────────────────

  /// Polls the scan status every [intervalSeconds] until `completed`
  /// or `failed`, then returns the full [ScanModel].
  ///
  /// Throws [ApiException] if max attempts reached or scan fails.
  Future<ScanModel> pollUntilDone(
    String scanId, {
    int intervalSeconds = 3,
    int maxAttempts = 40,
  }) async {
    for (var i = 0; i < maxAttempts; i++) {
      await Future.delayed(Duration(seconds: intervalSeconds));

      final status = await getScanStatus(scanId);

      if (status == 'completed') {
        return getScanById(scanId);
      }

      if (status == 'failed') {
        throw const ApiException(
          statusCode: 422,
          message: 'Scan processing failed on server',
        );
      }
      // queued / processing → keep polling
    }

    throw const ApiException(
      statusCode: 408,
      message: 'Scan timed out — please try again',
    );
  }

  // ─── GET /scans ────────────────────────────────────────────────────────

  /// Returns all scans for the authenticated user.
  Future<List<ScanModel>> getScans({int page = 1, int limit = 20}) async {
    try {
      final response = await _client.get('/scans', queryParameters: {
        'page': page,
        'limit': limit,
      });
      final raw = response.data;
      List<dynamic> list;
      if (raw is Map && raw['data'] is List) {
        list = raw['data'] as List;
      } else if (raw is List) {
        list = raw;
      } else {
        list = [];
      }
      return list
          .map((e) => ScanModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }
}
