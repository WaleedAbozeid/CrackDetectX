import '../models/admin_models.dart';
import '../store/app_state.dart';

/// Admin Permission Guard Service.
///
/// Uses `currentUser.userType` from [AppState] (sourced from the backend JWT)
/// as the single source of truth. No Firebase fallback.
class AdminGuard {
  /// Returns true if the logged-in user has admin privileges.
  static bool isAdmin(AppState appState) {
    return appState.isAdmin;
  }

  /// Checks if user has a specific permission.
  /// Currently all admins have all permissions (can be extended per role).
  static bool hasPermission(AppState appState, AdminPermission permission) {
    return isAdmin(appState);
  }

  static bool hasAnyPermission(
    AppState appState,
    List<AdminPermission> permissions,
  ) {
    return isAdmin(appState);
  }

  static bool hasAllPermissions(
    AppState appState,
    List<AdminPermission> permissions,
  ) {
    return isAdmin(appState);
  }

  static bool hasRole(AppState appState, AdminRole role) {
    return isAdmin(appState);
  }

  static bool isSuperAdmin(AppState appState) {
    return isAdmin(appState);
  }

  // ─── Feature permission checks ─────────────────────────────────────────

  static bool canManageVerifications(AppState appState) => isAdmin(appState);
  static bool canResolveDisputes(AppState appState) => isAdmin(appState);
  static bool canEditSystemConfig(AppState appState) => isAdmin(appState);
  static bool canViewAuditLogs(AppState appState) => isAdmin(appState);
  static bool canManageUsers(AppState appState) => isAdmin(appState);
  static bool canManagePayments(AppState appState) => isAdmin(appState);

  // ─── Guard helpers ─────────────────────────────────────────────────────

  static void requirePermission(
    AppState appState,
    AdminPermission permission, {
    String? message,
  }) {
    if (!hasPermission(appState, permission)) {
      throw AdminPermissionException(
        message ?? 'Insufficient permissions: ${permission.toString()}',
      );
    }
  }

  static void requireAdmin(AppState appState, {String? message}) {
    if (!isAdmin(appState)) {
      throw AdminPermissionException(message ?? 'Admin access required');
    }
  }
}

/// Exception thrown when admin permission is insufficient.
class AdminPermissionException implements Exception {
  final String message;
  AdminPermissionException(this.message);

  @override
  String toString() => 'AdminPermissionException: $message';
}
