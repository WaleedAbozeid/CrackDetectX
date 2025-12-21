import 'package:uuid/uuid.dart';

enum CompanySpecialization {
  structural,
  safety,
  repair,
  inspection,
  consultation,
  monitoring,
}

class Company {
  final String id;
  final String name;
  final String logoUrl;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final bool isTopRated;
  final String description;
  final String location;
  final int projectsCompleted;
  final List<CompanySpecialization> specializations;
  final String email;
  final String phoneNumber;

  Company({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.isTopRated,
    required this.description,
    required this.location,
    required this.projectsCompleted,
    required this.specializations,
    required this.email,
    required this.phoneNumber,
  });

  factory Company.createDummy({
    required String name,
    required String description,
    required String location,
    double rating = 4.5,
    bool verified = false,
  }) {
    return Company(
      id: const Uuid().v4(),
      name: name,
      logoUrl: 'assets/icons/company_logo_placeholder.png',
      rating: rating,
      reviewCount: (rating * 20).toInt(),
      isVerified: verified,
      isTopRated: rating >= 4.8,
      description: description,
      location: location,
      projectsCompleted: (rating * 50).toInt(),
      specializations: [
        CompanySpecialization.structural,
        CompanySpecialization.repair,
      ],
      email: 'contact@${name.replaceAll(' ', '').toLowerCase()}.com',
      phoneNumber: '+201000000000',
    );
  }
}

enum RequestStatus {
  draft,
  posted,
  bidding,
  awarded,
  inProgress,
  completed,
  closed,
  cancelled,
  disputed,
}

enum RiskLevel { low, medium, high }

class RepairRequest {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final List<String> images;
  final String location;
  final RequestStatus status;

  // New Fields
  final double? budgetMin;
  final double? budgetMax;
  final RiskLevel riskLevel;
  final String? aiReportId;

  final DateTime createdAt;
  final DateTime? biddingEndsAt;
  final DateTime? completedAt;

  const RepairRequest({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.images,
    required this.location,
    this.status = RequestStatus.draft,
    this.budgetMin,
    this.budgetMax,
    this.riskLevel = RiskLevel.low,
    this.aiReportId,
    required this.createdAt,
    this.biddingEndsAt,
    this.completedAt,
  });

  RepairRequest copyWith({
    String? title,
    String? description,
    List<String>? images,
    String? location,
    RequestStatus? status,
    double? budgetMin,
    double? budgetMax,
    RiskLevel? riskLevel,
    String? aiReportId,
    DateTime? completedAt,
    DateTime? biddingEndsAt,
  }) {
    return RepairRequest(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      location: location ?? this.location,
      status: status ?? this.status,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      riskLevel: riskLevel ?? this.riskLevel,
      aiReportId: aiReportId ?? this.aiReportId,
      createdAt: createdAt,
      biddingEndsAt: biddingEndsAt ?? this.biddingEndsAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

enum BidStatus { pending, accepted, rejected, withdrawn }

class Bid {
  final String id;
  final String requestId;
  final String engineerId;
  final String engineerName; // Snapshot
  final double price;
  final int durationDays;
  final String proposal;

  // New Fields
  final int warrantyMonths;
  final String? methodDescription;

  final BidStatus status;
  final DateTime createdAt;

  const Bid({
    required this.id,
    required this.requestId,
    required this.engineerId,
    required this.engineerName,
    required this.price,
    required this.durationDays,
    required this.proposal,
    this.warrantyMonths = 0,
    this.methodDescription,
    this.status = BidStatus.pending,
    required this.createdAt,
  });

  Bid copyWith({BidStatus? status}) {
    return Bid(
      id: id,
      requestId: requestId,
      engineerId: engineerId,
      engineerName: engineerName,
      price: price,
      durationDays: durationDays,
      proposal: proposal,
      warrantyMonths: warrantyMonths,
      methodDescription: methodDescription,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
