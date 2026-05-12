/// Unified exception type for all backend API errors.
///
/// Thrown by [ApiClient] whenever the server returns a non-2xx response
/// or when a network/timeout error occurs.
class ApiException implements Exception {
  /// HTTP status code (400, 401, 403, 404, 422, 500, …).
  /// Use 0 for network/connectivity errors.
  final int statusCode;

  /// Human-readable error message (from server or generated locally).
  final String message;

  /// Field-level validation errors returned by the server (422 responses).
  /// Key = field name, Value = list of error strings.
  final Map<String, dynamic>? fieldErrors;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.fieldErrors,
  });

  // ─── Named constructors ────────────────────────────────────────────────

  factory ApiException.network() => const ApiException(
        statusCode: 0,
        message: 'تحقق من اتصالك بالإنترنت',
      );

  factory ApiException.timeout() => const ApiException(
        statusCode: 408,
        message: 'انتهت مهلة الطلب، حاول مجدداً',
      );

  factory ApiException.unauthorized() => const ApiException(
        statusCode: 401,
        message: 'جلستك انتهت، سجّل الدخول مجدداً',
      );

  factory ApiException.forbidden() => const ApiException(
        statusCode: 403,
        message: 'ليس لديك صلاحية للوصول لهذا المورد',
      );

  factory ApiException.notFound() => const ApiException(
        statusCode: 404,
        message: 'المورد المطلوب غير موجود',
      );

  factory ApiException.serverError() => const ApiException(
        statusCode: 500,
        message: 'خطأ في الخادم، حاول لاحقاً',
      );

  // ─── Helpers ──────────────────────────────────────────────────────────

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidation => statusCode == 422;
  bool get isNetworkError => statusCode == 0;
  bool get isServerError => statusCode >= 500;

  /// Returns the first validation error for [field], or null.
  String? fieldError(String field) {
    final errors = fieldErrors?[field];
    if (errors is List && errors.isNotEmpty) return errors.first.toString();
    if (errors is String) return errors;
    return null;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
