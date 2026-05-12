import 'package:dio/dio.dart';
import '../core/api_exception.dart';
import '../core/env.dart';
import '../models/auth_tokens.dart';
import '../services/token_storage_service.dart';

/// Central HTTP client for all backend communication.
///
/// Features:
/// - Automatic `Authorization: Bearer <token>` injection
/// - Automatic token refresh on 401 (single retry)
/// - Unified error mapping → [ApiException]
/// - Request/response logging in debug mode
///
/// Usage:
/// ```dart
/// final client = ApiClient.instance;
/// final response = await client.get('/buildings');
/// ```
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio _dio;
  bool _initialized = false;

  // ─── Init ──────────────────────────────────────────────────────────────

  /// Must be called once at app startup (before any API call).
  Future<void> init() async {
    if (_initialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.baseUrl,
        connectTimeout: Duration(seconds: AppEnv.connectTimeoutSeconds),
        receiveTimeout: Duration(seconds: AppEnv.receiveTimeoutSeconds),
        sendTimeout:    Duration(seconds: AppEnv.uploadTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _RefreshInterceptor(_dio),
      _ErrorInterceptor(),
      if (_isDebug) LogInterceptor(requestBody: true, responseBody: true),
    ]);

    _initialized = true;
  }

  static bool get _isDebug {
    bool debug = false;
    assert(() {
      debug = true;
      return true;
    }());
    return debug;
  }

  // ─── Public HTTP methods ───────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInit();
    return _dio.get<T>(path,
        queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _ensureInit();
    return _dio.post<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    _ensureInit();
    return _dio.put<T>(path, data: data, options: options);
  }

  Future<Response<T>> delete<T>(
    String path, {
    Options? options,
  }) async {
    _ensureInit();
    return _dio.delete<T>(path, options: options);
  }

  void _ensureInit() {
    if (!_initialized) {
      throw StateError(
          'ApiClient not initialized. Call ApiClient.instance.init() first.');
    }
  }
}

// ─── Auth Interceptor ────────────────────────────────────────────────────────

/// Injects `Authorization: Bearer <token>` into every request that doesn't
/// already have an Authorization header.
class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey('Authorization')) {
      final token = await TokenStorageService.instance.accessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

// ─── Refresh Interceptor ─────────────────────────────────────────────────────

/// On 401, tries to refresh the access token once, then retries the original
/// request. If refresh also fails, clears tokens and lets the error propagate
/// (UI should redirect to login).
class _RefreshInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;

  _RefreshInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await TokenStorageService.instance.refreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          await TokenStorageService.instance.clear();
          _isRefreshing = false;
          handler.next(err);
          return;
        }

        // Call refresh endpoint with a fresh Dio instance (no interceptors)
        final refreshDio = Dio(BaseOptions(
          baseUrl: AppEnv.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ));

        final refreshResponse = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newTokens = AuthTokens.fromLoginResponse(
          refreshResponse.data as Map<String, dynamic>,
        );
        await TokenStorageService.instance.save(newTokens);

        // Retry original request with new token
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] =
            'Bearer ${newTokens.accessToken}';

        final retryResponse = await _dio.fetch(retryOptions);
        handler.resolve(retryResponse);
      } catch (_) {
        // Refresh failed → clear tokens so AuthGuard redirects to login
        await TokenStorageService.instance.clear();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }
}

// ─── Error Interceptor ───────────────────────────────────────────────────────

/// Maps [DioException] → [ApiException] for clean error handling in the UI.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiException apiException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        apiException = ApiException.timeout();
        break;

      case DioExceptionType.connectionError:
        apiException = ApiException.network();
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final responseData = err.response?.data;

        String message;
        Map<String, dynamic>? fieldErrors;

        if (responseData is Map<String, dynamic>) {
          message = (responseData['message'] ??
                  responseData['error'] ??
                  _defaultMessage(statusCode))
              .toString();

          // 422 field errors: { "errors": { "email": ["..."] } }
          if (responseData['errors'] is Map) {
            fieldErrors =
                Map<String, dynamic>.from(responseData['errors'] as Map);
          }
        } else {
          message = _defaultMessage(statusCode);
        }

        apiException = ApiException(
          statusCode: statusCode,
          message: message,
          fieldErrors: fieldErrors,
        );
        break;

      default:
        apiException = ApiException.network();
    }

    // Replace the DioException with ApiException
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: apiException,
        type: err.type,
        response: err.response,
      ),
    );
  }

  static String _defaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صالح';
      case 401:
        return 'جلستك انتهت، سجّل الدخول مجدداً';
      case 403:
        return 'ليس لديك صلاحية للوصول';
      case 404:
        return 'المورد المطلوب غير موجود';
      case 422:
        return 'تحقق من البيانات المدخلة';
      case 500:
        return 'خطأ في الخادم، حاول لاحقاً';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}

// ─── Helper extension ────────────────────────────────────────────────────────

/// Extracts [ApiException] from a [DioException] error chain.
extension DioExceptionX on DioException {
  ApiException? get apiException {
    final e = error;
    if (e is ApiException) return e;
    return null;
  }
}
