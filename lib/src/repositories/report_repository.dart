import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../ai/types.dart';

/// Repository for Report CRUD operations.
///
/// Endpoints used:
/// - `GET    /reports`        — list user's reports
/// - `POST   /reports`        — create report from scan
/// - `GET    /reports/{id}`   — get single report
/// - `DELETE /reports/{id}`   — delete report
///
/// Note: [Report] model re-uses the existing `building_models.dart` definition.
class ReportRepository {
  ReportRepository._();
  static final ReportRepository instance = ReportRepository._();

  final ApiClient _client = ApiClient.instance;

  // ─── GET /reports ─────────────────────────────────────────────────────

  Future<List<Report>> getReports({int page = 1, int limit = 20}) async {
    try {
      final response = await _client.get('/reports', queryParameters: {
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
          .map((e) => Report.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /reports/{id} ────────────────────────────────────────────────

  Future<Report> getReportById(String id) async {
    try {
      final response = await _client.get('/reports/$id');
      final data = (response.data['data'] ?? response.data) as Map<String, dynamic>;
      return Report.fromJson(data);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── POST /reports ────────────────────────────────────────────────────

  /// Creates a report linked to a completed scan.
  Future<Report> createReport({
    required String scanId,
    required String title,
    String? buildingId,
    String? notes,
  }) async {
    try {
      final response = await _client.post('/reports', data: {
        'scan_id': scanId,
        'title': title.trim(),
        'building_id': buildingId,
        if (notes != null && notes.isNotEmpty) 'notes': notes.trim(),
      });
      final data = (response.data['data'] ?? response.data) as Map<String, dynamic>;
      return Report.fromJson(data);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── DELETE /reports/{id} ─────────────────────────────────────────────

  Future<void> deleteReport(String id) async {
    try {
      await _client.delete('/reports/$id');
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }
}
