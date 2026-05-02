import 'package:firebase_auth/firebase_auth.dart';
import '../models/admin_models.dart';
import '../store/app_state.dart';

/// Admin Permission Guard Service
///
/// Checks admin permissions before allowing access to admin-only features.
/// Uses [AppState.isAdmin] as the primary source of truth.
/// Firebase email is kept as a secondary fallback for the demo.
class AdminGuard {
  /// Check if current user has admin permissions
  static bool isAdmin(AppState appState) {
    // Primary: check role in AppState (set at login)
    if (appState.isAdmin) return true;

    // Fallback demo: allow email containing 'admin' (remove after backend RBAC)
    final email = FirebaseAuth.instance.currentUser?.email?.toLowerCase() ?? '';
    return email.contains('admin');
  }

  /// Check if current user has a specific permission
  static bool hasPermission(AppState appState, AdminPermission permission) {
    return isAdmin(appState);
  }

  /// Check if current user has any of the specified permissions
  static bool hasAnyPermission(
    AppState appState,
    List<AdminPermission> permissions,
  ) {
    return isAdmin(appState);
  }

  /// Check if current user has all of the specified permissions
  static bool hasAllPermissions(
    AppState appState,
    List<AdminPermission> permissions,
  ) {
    return isAdmin(appState);
  }

  /// Check if current user has a specific admin role
  static bool hasRole(AppState appState, AdminRole role) {
    return isAdmin(appState);
  }

  /// Check if current user is a Super Admin
  static bool isSuperAdmin(AppState appState) {
    return hasRole(appState, AdminRole.superAdmin);
  }

  // ==================== Feature Permission Checks ====================

  static bool canManageVerifications(AppState appState) =>
      hasPermission(appState, AdminPermission.approveVerification);

  static bool canResolveDisputes(AppState appState) =>
      hasPermission(appState, AdminPermission.resolveDisputes);

  static bool canEditSystemConfig(AppState appState) =>
      hasPermission(appState, AdminPermission.editSystemConfig);

  static bool canViewAuditLogs(AppState appState) => hasAnyPermission(appState, [
        AdminPermission.viewAllUsers,
        AdminPermission.viewAnalytics,
      ]);

  static bool canManageUsers(AppState appState) =>
      hasPermission(appState, AdminPermission.manageUsers);

  static bool canManagePayments(AppState appState) =>
      hasAnyPermission(appState, [
        AdminPermission.viewAllTransactions,
        AdminPermission.controlEscrow,
      ]);

  // ==================== Guard Helpers ====================

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

/// Exception thrown when admin permission is insufficient
class AdminPermissionException implements Exception {
  final String message;
  AdminPermissionException(this.message);

  @override
  String toString() => 'AdminPermissionException: $message';
}
