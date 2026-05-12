import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/communication_models.dart';

/// Repository for app notifications.
///
/// Endpoints used (from Postman collection):
/// - `GET  /notifications`       — list all notifications for current user
/// - `POST /notifications/read`  — mark notification(s) as read
/// - `POST /notifications/read-all` — mark all as read
class NotificationsRepository {
  NotificationsRepository._();
  static final NotificationsRepository instance = NotificationsRepository._();

  final ApiClient _client = ApiClient.instance;

  // ─── GET /notifications ────────────────────────────────────────────────

  /// Fetches all notifications for the current logged-in user.
  Future<List<AppNotification>> getNotifications({bool? unreadOnly}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (unreadOnly == true) queryParams['unread'] = true;

      final response = await _client.get(
        '/notifications',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['notifications'] ?? []) as List<dynamic>;

      return list
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── POST /notifications/read ─────────────────────────────────────────

  /// Marks one or more notifications as read.
  ///
  /// [ids] — list of notification IDs to mark as read.
  Future<void> markRead(List<String> ids) async {
    try {
      await _client.post('/notifications/read', data: {'ids': ids});
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  /// Marks ALL notifications as read in one call.
  Future<void> markAllRead() async {
    try {
      await _client.post('/notifications/read-all');
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }
}
