import 'package:uuid/uuid.dart';

// ==================== ADMIN ROLE & PERMISSIONS ====================

enum AdminRole {
  superAdmin, // Full permissions
  moderator, // Content & disputes only
  financeAdmin, // Finance only
  supportAdmin, // Support only
}

enum AdminPermission {
  // User Management
  viewAllUsers,
  manageUsers,
  deleteUsers,
  changeUserRoles,
  forcePasswordReset,

  // Verification
  reviewDocuments,
  approveVerification,
  revokeVerification,

  // Marketplace
  viewAllRequests,
  viewAllBids,
  viewAllContracts,
  cancelRequestsForce,
  overrideProjectStatus,

  // Disputes
  viewAllDisputes,
  resolveDisputes,
  requestDocuments,

  // Payments
  viewAllTransactions,
  controlEscrow,
  setCommissionRate,
  blockWithdrawals,

  // AI
  viewAIReports,
  overrideAI,
  trackAIErrors,

  // System
  editSystemConfig,
  manageFeatureFlags,
  editPolicies,

  // Content
  moderateReviews,
  banUsers,

  // Analytics
  viewAnalytics,
  exportReports,
}

class AdminUser {
  final String id;
  final String email;
  final String fullName;
  final AdminRole role;
  final List<AdminPermission> permissions;
  final bool isActive;
  final DateTime createdAt;
  final String? createdBy;

  const AdminUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.permissions,
    this.isActive = true,
    required this.createdAt,
    this.createdBy,
  });

  // Get default permissions for role
  static List<AdminPermission> getDefaultPermissions(AdminRole role) {
    switch (role) {
      case AdminRole.superAdmin:
        return AdminPermission.values; // All permissions

      case AdminRole.moderator:
        return [
          AdminPermission.viewAllUsers,
          AdminPermission.viewAllDisputes,
          AdminPermission.resolveDisputes,
          AdminPermission.moderateReviews,
          AdminPermission.banUsers,
        ];

      case AdminRole.financeAdmin:
        return [
          AdminPermission.viewAllTransactions,
          AdminPermission.controlEscrow,
          AdminPermission.setCommissionRate,
          AdminPermission.blockWithdrawals,
          AdminPermission.viewAnalytics,
          AdminPermission.exportReports,
        ];

      case AdminRole.supportAdmin:
        return [
          AdminPermission.viewAllUsers,
          AdminPermission.viewAllRequests,
          AdminPermission.viewAllDisputes,
          AdminPermission.requestDocuments,
        ];
    }
  }

  bool hasPermission(AdminPermission permission) {
    return permissions.contains(permission);
  }

  AdminUser copyWith({
    String? email,
    String? fullName,
    AdminRole? role,
    List<AdminPermission>? permissions,
    bool? isActive,
  }) {
    return AdminUser(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}

// ==================== AUDIT LOG ====================

enum AdminActionType {
  // User Management
  userActivated,
  userDeactivated,
  userDeleted,
  userRestored,
  userRoleChanged,
  passwordResetForced,

  // Verification
  verificationApproved,
  verificationRejected,
  verificationRevoked,
  trustLevelChanged,

  // Marketplace
  requestCancelled,
  bidCancelled,
  contractCancelled,
  projectStatusOverridden,

  // Disputes
  disputeResolved,
  documentsRequested,

  // Payments
  escrowReleased,
  escrowRefunded,
  withdrawalBlocked,
  withdrawalUnblocked,
  commissionRateChanged,

  // AI
  aiDecisionOverridden,
  manualReviewForced,

  // System
  configChanged,
  featureFlagToggled,
  policyUpdated,

  // Content
  reviewDeleted,
  reviewHidden,
  userBanned,
  userUnbanned,
}

class AuditLog {
  final String id;
  final String adminId;
  final String adminName;
  final AdminActionType action;
  final String targetType; // 'user', 'request', 'contract', etc.
  final String targetId;
  final Map<String, dynamic> oldValue;
  final Map<String, dynamic> newValue;
  final String reason; // Mandatory for all actions
  final DateTime timestamp;
  final String ipAddress;
  final bool reversible; // Can this action be undone?

  const AuditLog({
    required this.id,
    required this.adminId,
    required this.adminName,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.oldValue,
    required this.newValue,
    required this.reason,
    required this.timestamp,
    required this.ipAddress,
    this.reversible = false,
  });

  factory AuditLog.create({
    required String adminId,
    required String adminName,
    required AdminActionType action,
    required String targetType,
    required String targetId,
    required Map<String, dynamic> oldValue,
    required Map<String, dynamic> newValue,
    required String reason,
    required String ipAddress,
    bool reversible = false,
  }) {
    return AuditLog(
      id: 'audit_${const Uuid().v4()}',
      adminId: adminId,
      adminName: adminName,
      action: action,
      targetType: targetType,
      targetId: targetId,
      oldValue: oldValue,
      newValue: newValue,
      reason: reason,
      timestamp: DateTime.now(),
      ipAddress: ipAddress,
      reversible: reversible,
    );
  }
}

// ==================== VERIFICATION REQUEST ====================

enum VerificationRequestStatus {
  pending,
  underReview,
  approved,
  rejected,
  revoked,
  documentsRequested,
}

enum TrustLevel {
  none,
  junior, // <2 years experience
  mid, // 2-5 years
  senior, // 5-10 years
  expert, // 10+ years
}

class VerificationRequest {
  final String id;
  final String userId;
  final String userRole; // 'engineer' or 'company'

  // For Engineers
  final String? syndicateNumber;
  final List<String> certificateUrls;
  final List<String> portfolioUrls;
  final int? yearsOfExperience;

  // For Companies
  final String? tradeLicense;
  final String? taxId;
  final String? companyLogo;

  final VerificationRequestStatus status;
  final TrustLevel trustLevel;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNotes;
  final String? rejectionReason;
  final DateTime submittedAt;

  const VerificationRequest({
    required this.id,
    required this.userId,
    required this.userRole,
    this.syndicateNumber,
    this.certificateUrls = const [],
    this.portfolioUrls = const [],
    this.yearsOfExperience,
    this.tradeLicense,
    this.taxId,
    this.companyLogo,
    this.status = VerificationRequestStatus.pending,
    this.trustLevel = TrustLevel.none,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNotes,
    this.rejectionReason,
    required this.submittedAt,
  });

  VerificationRequest copyWith({
    VerificationRequestStatus? status,
    TrustLevel? trustLevel,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNotes,
    String? rejectionReason,
  }) {
    return VerificationRequest(
      id: id,
      userId: userId,
      userRole: userRole,
      syndicateNumber: syndicateNumber,
      certificateUrls: certificateUrls,
      portfolioUrls: portfolioUrls,
      yearsOfExperience: yearsOfExperience,
      tradeLicense: tradeLicense,
      taxId: taxId,
      companyLogo: companyLogo,
      status: status ?? this.status,
      trustLevel: trustLevel ?? this.trustLevel,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      submittedAt: submittedAt,
    );
  }
}

// ==================== SYSTEM CONFIGURATION ====================

class SystemConfig {
  final String id;

  // Marketplace Settings
  final int biddingWindowDays;
  final int minBudget;
  final int maxBudget;
  final int defaultWarrantyMonths;
  final double platformCommissionRate; // %

  // Geographic Settings
  final List<String> supportedCities;
  final int maxSearchRadiusKm;

  // AI Settings
  final bool aiAutoApproveEnabled;
  final double aiConfidenceThreshold;
  final bool forceManualReviewHighRisk;

  // Policies
  final int refundWindowDays;
  final int disputeResponseDays;
  final int maxReviewEditDays;

  // Feature Flags
  final Map<String, bool> features;

  final DateTime lastUpdatedAt;
  final String lastUpdatedBy;

  const SystemConfig({
    required this.id,
    this.biddingWindowDays = 7,
    this.minBudget = 1000,
    this.maxBudget = 1000000,
    this.defaultWarrantyMonths = 12,
    this.platformCommissionRate = 5.0,
    this.supportedCities = const ['Cairo', 'Giza', 'Alexandria'],
    this.maxSearchRadiusKm = 50,
    this.aiAutoApproveEnabled = false,
    this.aiConfidenceThreshold = 0.85,
    this.forceManualReviewHighRisk = true,
    this.refundWindowDays = 7,
    this.disputeResponseDays = 3,
    this.maxReviewEditDays = 7,
    this.features = const {},
    required this.lastUpdatedAt,
    required this.lastUpdatedBy,
  });

  SystemConfig copyWith({
    int? biddingWindowDays,
    int? minBudget,
    int? maxBudget,
    int? defaultWarrantyMonths,
    double? platformCommissionRate,
    List<String>? supportedCities,
    int? maxSearchRadiusKm,
    bool? aiAutoApproveEnabled,
    double? aiConfidenceThreshold,
    bool? forceManualReviewHighRisk,
    int? refundWindowDays,
    int? disputeResponseDays,
    int? maxReviewEditDays,
    Map<String, bool>? features,
    DateTime? lastUpdatedAt,
    String? lastUpdatedBy,
  }) {
    return SystemConfig(
      id: id,
      biddingWindowDays: biddingWindowDays ?? this.biddingWindowDays,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      defaultWarrantyMonths:
          defaultWarrantyMonths ?? this.defaultWarrantyMonths,
      platformCommissionRate:
          platformCommissionRate ?? this.platformCommissionRate,
      supportedCities: supportedCities ?? this.supportedCities,
      maxSearchRadiusKm: maxSearchRadiusKm ?? this.maxSearchRadiusKm,
      aiAutoApproveEnabled: aiAutoApproveEnabled ?? this.aiAutoApproveEnabled,
      aiConfidenceThreshold:
          aiConfidenceThreshold ?? this.aiConfidenceThreshold,
      forceManualReviewHighRisk:
          forceManualReviewHighRisk ?? this.forceManualReviewHighRisk,
      refundWindowDays: refundWindowDays ?? this.refundWindowDays,
      disputeResponseDays: disputeResponseDays ?? this.disputeResponseDays,
      maxReviewEditDays: maxReviewEditDays ?? this.maxReviewEditDays,
      features: features ?? this.features,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }
}
