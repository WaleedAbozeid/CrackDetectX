import 'dart:convert';

/// Data model for the authenticated user — mirrors the backend `/users/me` response.
///
/// Field names follow the Postman Collection v5 contract:
/// ```json
/// {
///   "data": {
///     "id": "...",
///     "full_name": "...",
///     "email": "...",
///     "phone": "...",
///     "user_type": "owner | field_engineer | repair_company | admin",
///     "is_verified": true,
///     "created_at": "2026-01-01T00:00:00Z"
///   }
/// }
/// ```
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;

  /// Role from backend: `field_engineer` | `building_owner` | `repair_company` | `admin`
  final String userType;
  final bool isVerified;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.userType,
    this.isVerified = false,
    this.createdAt,
  });

  // ─── Convenience getters ──────────────────────────────────────────────

  bool get isAdmin         => userType == 'admin';
  bool get isEngineer      => userType == 'field_engineer';
  bool get isBuildingOwner => userType == 'building_owner';
  bool get isRepairCompany => userType == 'repair_company';

  // ─── JSON ─────────────────────────────────────────────────────────────

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Support both top-level and nested `data` wrapper
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    return UserModel(
      id:          (data['id'] ?? data['user_id'] ?? '').toString(),
      fullName:    (data['full_name'] ?? data['name'] ?? '').toString(),
      email:       (data['email'] ?? '').toString(),
      phone:       data['phone']?.toString(),
      userType:    (data['user_type'] ?? data['role'] ?? 'field_engineer').toString(),
      isVerified:  (data['is_verified'] as bool?) ?? false,
      createdAt:   data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        if (phone != null) 'phone': phone,
        'user_type': userType,
        'is_verified': isVerified,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };

  // ─── Persistence ──────────────────────────────────────────────────────

  String encode() => jsonEncode(toJson());

  static UserModel? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // ─── CopyWith ─────────────────────────────────────────────────────────

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? userType,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id:          id ?? this.id,
      fullName:    fullName ?? this.fullName,
      email:       email ?? this.email,
      phone:       phone ?? this.phone,
      userType:    userType ?? this.userType,
      isVerified:  isVerified ?? this.isVerified,
      createdAt:   createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'UserModel($id, $email, $userType)';
}
