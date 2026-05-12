import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/auth_tokens.dart';
import '../models/user_model.dart';
import '../services/token_storage_service.dart';

/// Authentication service — JWT backend integration.
///
/// Replaces Firebase Auth entirely. Communicates with:
/// - `POST /auth/login`
/// - `POST /auth/register`
/// - `POST /auth/logout`
/// - `POST /auth/refresh`
/// - `POST /auth/forgot-password`
/// - `GET  /users/me`
/// - `PUT  /users/me`
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final ApiClient _client = ApiClient.instance;

  // ─── Auth State ────────────────────────────────────────────────────────

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // ─── Login ─────────────────────────────────────────────────────────────

  /// Authenticates with email + password.
  ///
  /// On success:
  /// 1. Saves [AuthTokens] via [TokenStorageService].
  /// 2. Fetches and caches [UserModel] via `GET /users/me`.
  ///
  /// Throws [ApiException] on failure.
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post('/auth/login', data: {
        'email': email.trim(),
        'password': password,
      });

      final tokens = AuthTokens.fromLoginResponse(
        response.data as Map<String, dynamic>,
      );
      await TokenStorageService.instance.save(tokens);

      // Fetch user profile to get role + info
      _currentUser = await fetchCurrentUser();
      return _currentUser!;
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Register ──────────────────────────────────────────────────────────

  /// Registers a new account.
  ///
  /// [userType] must be one of:
  /// `field_engineer` | `building_owner` | `repair_company`
  ///
  /// On success, auto-logs in and returns [UserModel].
  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
    required String userType,
    String? phone,
  }) async {
    try {
      final response = await _client.post('/auth/register', data: {
        'full_name': fullName.trim(),
        'email': email.trim(),
        'password': password,
        'user_type': userType,
        if (phone != null && phone.isNotEmpty) 'phone': phone.trim(),
      });

      final tokens = AuthTokens.fromLoginResponse(
        response.data as Map<String, dynamic>,
      );
      await TokenStorageService.instance.save(tokens);

      _currentUser = await fetchCurrentUser();
      return _currentUser!;
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Logout ────────────────────────────────────────────────────────────

  /// Revokes refresh token on server then clears local tokens.
  Future<void> signOut() async {
    try {
      final refreshToken = await TokenStorageService.instance.refreshToken();
      if (refreshToken != null) {
        await _client.post('/auth/logout',
            data: {'refreshToken': refreshToken});
      }
    } catch (_) {
      // Best-effort — always clear local state
    } finally {
      await TokenStorageService.instance.clear();
      _currentUser = null;
    }
  }

  // ─── Forgot Password ──────────────────────────────────────────────────

  Future<void> forgotPassword(String email) async {
    try {
      await _client.post('/auth/forgot-password',
          data: {'email': email.trim()});
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── User Profile ─────────────────────────────────────────────────────

  /// Fetches the current user from `GET /users/me` and caches it.
  Future<UserModel> fetchCurrentUser() async {
    try {
      final response = await _client.get('/users/me');
      _currentUser = UserModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return _currentUser!;
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  /// Updates user profile via `PUT /users/me`.
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
  }) async {
    try {
      final response = await _client.put('/users/me', data: {
        if (fullName != null) 'full_name': fullName.trim(),
        if (phone != null) 'phone': phone.trim(),
      });
      _currentUser = UserModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return _currentUser!;
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Session restore ──────────────────────────────────────────────────

  /// Called at app startup. Tries to restore session from saved tokens.
  ///
  /// Returns [UserModel] if session is valid, null otherwise.
  Future<UserModel?> restoreSession() async {
    final token = await TokenStorageService.instance.accessToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await fetchCurrentUser();
    } catch (_) {
      // Token might be expired — clear and let user re-login
      await TokenStorageService.instance.clear();
      return null;
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────

  /// Logs out — calls `POST /auth/logout`, then clears local tokens + cache.
  Future<void> logout() async {
    try {
      await _client.post('/auth/logout', data: {});
    } catch (_) {
      // Best-effort — always clear locally even if API fails
    }
    await TokenStorageService.instance.clear();
    _currentUser = null;
  }

  // ─── Helper: map backend user_type → UserRole enum ───────────────────

  /// Maps backend `user_type` string to the local [UserRoleMapper].
  static String userTypeToDisplayName(String userType) {
    switch (userType) {
      case 'admin':
        return 'Admin';
      case 'field_engineer':
        return 'Field Engineer';
      case 'building_owner':
        return 'Building Owner';
      case 'repair_company':
        return 'Repair Company';
      default:
        return userType;
    }
  }
}
