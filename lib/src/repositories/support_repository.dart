import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/communication_models.dart';

/// Repository for support ticket operations.
///
/// Endpoints used (from Postman collection):
/// - `POST /support`       — create a new support ticket
/// - `GET  /support`       — list current user's tickets
/// - `GET  /support/{id}`  — get a single ticket with its replies
class SupportRepository {
  SupportRepository._();
  static final SupportRepository instance = SupportRepository._();

  final ApiClient _client = ApiClient.instance;

  // ─── POST /support ────────────────────────────────────────────────────

  /// Creates a new support ticket.
  ///
  /// Returns the created [SupportTicket].
  Future<SupportTicket> createTicket({
    required String subject,
    required String description,
    String priority = 'medium',
  }) async {
    try {
      final response = await _client.post('/support', data: {
        'subject': subject.trim(),
        'description': description.trim(),
        'priority': priority,
      });
      return SupportTicket.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /support ─────────────────────────────────────────────────────

  /// Lists all support tickets for the current user.
  Future<List<SupportTicket>> getTickets() async {
    try {
      final response = await _client.get('/support');
      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['tickets'] ?? []) as List<dynamic>;

      return list
          .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /support/{id} ───────────────────────────────────────────────

  /// Gets full details of a single ticket (with replies if any).
  Future<SupportTicket> getTicket(String ticketId) async {
    try {
      final response = await _client.get('/support/$ticketId');
      return SupportTicket.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }
}
