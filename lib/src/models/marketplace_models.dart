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

// ==================== CONTRACT MODEL ====================

enum ContractStatus {
  draft, // Created but not signed
  active, // Signed and ready to start
  inProgress, // Work is ongoing
  pendingCompletion, // Engineer marked complete, awaiting owner approval
  completed, // Completed and approved
  disputed, // There's a dispute
  cancelled, // Cancelled
}

class Contract {
  final String id;
  final String requestId;
  final String ownerId;
  final String engineerId;
  final String engineerName; // Snapshot
  final String bidId;
  final double agreedPrice;
  final int agreedDuration;
  final int warrantyMonths;
  final String? methodology;

  final ContractStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  final String? completionNotes;
  final bool engineerMarkedComplete;
  final bool ownerApproved;
  final String? ownerFeedback;

  const Contract({
    required this.id,
    required this.requestId,
    required this.ownerId,
    required this.engineerId,
    required this.engineerName,
    required this.bidId,
    required this.agreedPrice,
    required this.agreedDuration,
    this.warrantyMonths = 0,
    this.methodology,
    this.status = ContractStatus.draft,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.completionNotes,
    this.engineerMarkedComplete = false,
    this.ownerApproved = false,
    this.ownerFeedback,
  });

  Contract copyWith({
    ContractStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    String? completionNotes,
    bool? engineerMarkedComplete,
    bool? ownerApproved,
    String? ownerFeedback,
  }) {
    return Contract(
      id: id,
      requestId: requestId,
      ownerId: ownerId,
      engineerId: engineerId,
      engineerName: engineerName,
      bidId: bidId,
      agreedPrice: agreedPrice,
      agreedDuration: agreedDuration,
      warrantyMonths: warrantyMonths,
      methodology: methodology,
      status: status ?? this.status,
      createdAt: createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      completionNotes: completionNotes ?? this.completionNotes,
      engineerMarkedComplete:
          engineerMarkedComplete ?? this.engineerMarkedComplete,
      ownerApproved: ownerApproved ?? this.ownerApproved,
      ownerFeedback: ownerFeedback ?? this.ownerFeedback,
    );
  }
}

// ==================== DISPUTE MODEL ====================

enum DisputeStatus {
  open, // Newly created
  underReview, // Being reviewed (admin/system)
  resolved, // Resolved
  closed, // Closed without resolution
}

class Dispute {
  final String id;
  final String contractId;
  final String raisedBy; // userId (owner or engineer)
  final String raisedByName;
  final String reason;
  final String description;
  final DisputeStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolution;

  const Dispute({
    required this.id,
    required this.contractId,
    required this.raisedBy,
    required this.raisedByName,
    required this.reason,
    required this.description,
    this.status = DisputeStatus.open,
    required this.createdAt,
    this.resolvedAt,
    this.resolution,
  });

  Dispute copyWith({
    DisputeStatus? status,
    DateTime? resolvedAt,
    String? resolution,
  }) {
    return Dispute(
      id: id,
      contractId: contractId,
      raisedBy: raisedBy,
      raisedByName: raisedByName,
      reason: reason,
      description: description,
      status: status ?? this.status,
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolution: resolution ?? this.resolution,
    );
  }
}

// ==================== REVIEW MODEL ====================

class Review {
  final String id;
  final String contractId;
  final String reviewerId; // Who is giving the review
  final String reviewerName;
  final String revieweeId; // Who is being reviewed
  final String revieweeName;
  final double rating; // 1-5
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.contractId,
    required this.reviewerId,
    required this.reviewerName,
    required this.revieweeId,
    required this.revieweeName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
