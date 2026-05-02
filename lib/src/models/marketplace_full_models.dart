enum UserRole {
  owner,
  engineer,
  companyAdmin,
  companyAccountant,
  admin, // System admin
}

enum VerificationStatus { none, pending, verified, rejected }

/// Extended User Model
class AppUser {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final String? profileImageUrl;
  final DateTime createdAt;

  // For Engineer/Company specific linking
  final String? companyId;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    this.verificationStatus = VerificationStatus.none,
    this.profileImageUrl,
    this.companyId,
    required this.createdAt,
  });

  AppUser copyWith({
    String? fullName,
    String? phone,
    UserRole? role,
    VerificationStatus? verificationStatus,
    String? profileImageUrl,
    String? companyId,
  }) {
    return AppUser(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt,
    );
  }
}

/// Company Entity
class Company {
  final String id;
  final String name;
  final String? logoUrl;
  final String tradeLicenseNumber;
  final String? taxId;
  final bool isVerified;
  final DateTime createdAt;
  final List<String> specializedServices;

  const Company({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.tradeLicenseNumber,
    this.taxId,
    this.isVerified = false,
    required this.createdAt,
    this.specializedServices = const [],
  });
}

/// Engineer Professional Profile
class EngineerProfile {
  final String userId;
  final String syndicateCardNumber;
  final int yearsOfExperience;
  final List<String> specializations;
  final String? bio;
  final String? portfolioUrl;

  const EngineerProfile({
    required this.userId,
    required this.syndicateCardNumber,
    required this.yearsOfExperience,
    required this.specializations,
    this.bio,
    this.portfolioUrl,
  });
}
