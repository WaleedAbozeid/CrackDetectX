import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ai/types.dart';
import '../models/todo.dart';
import '../models/marketplace_models.dart';
import '../models/marketplace_full_models.dart' hide Company;
import '../models/admin_models.dart';
import '../models/communication_models.dart';
import '../models/offline_models.dart';
import '../models/building_models.dart';
import '../core/constants.dart';

/// Global application state management using Provider pattern
/// 
/// Manages:
/// - Selected image for processing
/// - Detection results from AI model
/// - Reports history
/// - Todo list items
class AppState extends ChangeNotifier {
  String? _selectedImagePath;
  DetectionResult? _detectionResult;
  final List<Report> _reports = [];
  final List<Todo> _todos = [];

  // ==================== UI Preferences ====================
  // These are intentionally in-memory for now (persistence comes later).
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');

  // ==================== Marketplace (In-Memory API Contract) ====================
  final List<RepairRequest> _marketRequests = [];
  final List<Bid> _bids = [];
  final List<Contract> _contracts = [];
  final List<Dispute> _disputes = [];
  final List<Review> _reviews = [];
  final List<Company> _companies = [];

  // ==================== Admin / System (In-Memory) ====================
  final List<VerificationRequest> _pendingVerifications = [];
  SystemConfig? _systemConfig;
  final List<AuditLog> _auditLogs = [];

  // ==================== Support & Notifications (In-Memory) ====================
  final List<SupportTicket> _supportTickets = [];
  final List<AppNotification> _notifications = [];

  // ==================== Offline-First ====================
  bool _isOnline = true;
  final List<OfflineDraft> _offlineDrafts = [];

  // ==================== Role-Based Access ====================
  UserRole _currentUserRole = UserRole.engineer; // default للـ demo

  // ==================== Buildings & Projects ====================
  final List<Building> _buildings = [];
  final List<Project> _projects = [];
  final List<Annotation> _annotations = [];

  AppState() {
    _seedDummyData();
    _loadPersistedData();
  }

  // ==================== Getters ====================
  
  /// Currently selected image path for processing
  String? get selectedImagePath => _selectedImagePath;

  /// Latest detection result from AI processing
  DetectionResult? get detectionResult => _detectionResult;

  /// All saved reports (immutable list)
  List<Report> get reports => List.unmodifiable(_reports);

  /// All todo items (immutable list)
  List<Todo> get todos => List.unmodifiable(_todos);

  /// Active (incomplete) todo items
  List<Todo> get activeTodos => _todos.where((t) => !t.isCompleted).toList();

  /// Completed todo items
  List<Todo> get completedTodos => _todos.where((t) => t.isCompleted).toList();

  /// Total number of reports
  int get reportsCount => _reports.length;

  /// Total number of todos
  int get todosCount => _todos.length;

  // ==================== Role Getters ====================

  /// Current user role (mock until backend JWT is wired)
  UserRole get currentUserRole => _currentUserRole;

  bool get isAdmin    => _currentUserRole == UserRole.admin;
  bool get isEngineer => _currentUserRole == UserRole.engineer;
  bool get isOwner    => _currentUserRole == UserRole.owner;
  bool get isCompany  =>
      _currentUserRole == UserRole.companyAdmin ||
      _currentUserRole == UserRole.companyAccountant;

  // ==================== Building / Project / Annotation Getters ====================

  List<Building>   get buildings   => List.unmodifiable(_buildings);
  List<Project>    get projects    => List.unmodifiable(_projects);
  List<Annotation> get annotations => List.unmodifiable(_annotations);

  Building? getBuildingById(String id) =>
      _buildings.cast<Building?>().firstWhere((b) => b?.id == id, orElse: () => null);

  List<Annotation> annotationsForScan(String scanId) =>
      _annotations.where((a) => a.scanId == scanId).toList();

  // ==================== Image Management ====================

  /// Sets the selected image path for processing
  /// 
  /// [path] - File path of the selected image
  void setSelectedImage(String path) {
    if (_selectedImagePath != path) {
      _selectedImagePath = path;
      notifyListeners();
    }
  }

  // ==================== Building Selection ====================

  String? _selectedBuildingId;
  String? get selectedBuildingId => _selectedBuildingId;

  /// Sets the building linked to the current scan (nullable = no building)
  void setSelectedBuilding(String? buildingId) {
    _selectedBuildingId = buildingId;
    // no notifyListeners needed — used just before scan
  }

  /// Sets the detection result from AI processing
  /// 
  /// [result] - The detection result containing metrics and mask
  void setDetectionResult(DetectionResult result) {
    _detectionResult = result;
    notifyListeners();
  }

  /// Clears the current image selection and detection result
  void clearSelection() {
    if (_selectedImagePath != null || _detectionResult != null) {
      _selectedImagePath = null;
      _detectionResult = null;
      notifyListeners();
    }
  }

  // ==================== Report Management ====================

  /// Adds a new report to the reports list
  /// 
  /// [report] - The report to add
  /// Returns true if added successfully, false if report with same ID exists
  bool addReport(Report report) {
    if (_reports.any((r) => r.id == report.id)) {
      return false; // Report with this ID already exists
    }
    _reports.add(report);
    notifyListeners();
    return true;
  }

  /// Removes a report by its ID
  /// 
  /// [id] - The ID of the report to remove
  /// Returns true if removed, false if not found
  bool removeReport(String id) {
    final initialLength = _reports.length;
    _reports.removeWhere((report) => report.id == id);
    final removed = _reports.length < initialLength;
    if (removed) {
      notifyListeners();
    }
    return removed;
  }

  /// Clears all reports
  void clearReports() {
    if (_reports.isNotEmpty) {
      _reports.clear();
      notifyListeners();
    }
  }

  /// Gets a report by its ID
  /// 
  /// [id] - The ID of the report to retrieve
  /// Returns the report if found, null otherwise
  Report? getReportById(String id) {
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== Todo Management ====================

  /// Adds a new todo item
  /// 
  /// [title] - The title of the todo (required, non-empty)
  /// [description] - Optional description of the todo
  /// Returns the created todo, or null if title is empty
  Todo? addTodo(String title, [String description = '']) {
    if (title.trim().isEmpty) {
      return null; // Invalid title
    }

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
    );
    _todos.add(todo);
    notifyListeners();
    return todo;
  }

  /// Toggles the completion status of a todo
  /// 
  /// [id] - The ID of the todo to toggle
  /// Returns true if toggled, false if todo not found
  bool toggleTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) {
      return false; // Todo not found
    }

    final todo = _todos[index];
    _todos[index] = todo.copyWith(
      isCompleted: !todo.isCompleted,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
    );
    notifyListeners();
    return true;
  }

  /// Removes a todo by its ID
  /// 
  /// [id] - The ID of the todo to remove
  /// Returns true if removed, false if not found
  bool removeTodo(String id) {
    final initialLength = _todos.length;
    _todos.removeWhere((t) => t.id == id);
    final removed = _todos.length < initialLength;
    if (removed) {
      notifyListeners();
    }
    return removed;
  }

  /// Clears all completed todos
  /// 
  /// Returns the number of todos removed
  int clearCompletedTodos() {
    final initialLength = _todos.length;
    _todos.removeWhere((t) => t.isCompleted);
    final removedCount = initialLength - _todos.length;
    if (removedCount > 0) {
      notifyListeners();
    }
    return removedCount;
  }

  /// Gets a todo by its ID
  /// 
  /// [id] - The ID of the todo to retrieve
  /// Returns the todo if found, null otherwise
  Todo? getTodoById(String id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== Missing Mock Fields ====================
  // Theme and Locale
  ThemeMode get themeMode => _themeMode;
  void toggleTheme() {
    final next =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    if (next != _themeMode) {
      _themeMode = next;
      notifyListeners();
    }
  }

  Locale get locale => _locale;
  void toggleLanguage() {
    final next = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    if (next != _locale) {
      _locale = next;
      notifyListeners();
    }
  }

  // ==================== Offline-First Queue ====================
  bool get isOnline => _isOnline;

  /// Allows the app to simulate offline mode and sync queued drafts later.
  /// In the backend integration sprint, this will be replaced by real connectivity detection.
  void setOnline(bool value) {
    if (value == _isOnline) return;
    _isOnline = value;
    notifyListeners();

    if (_isOnline) {
      // Fire-and-forget sync.
      // ignore: unawaited_futures
      syncOfflineDrafts();
    }
  }

  List<OfflineDraft> get offlineDrafts => List.unmodifiable(_offlineDrafts);

  void saveOfflineDraft(RepairRequest request) {
    final draft = OfflineDraft(
      id: 'draft_${DateTime.now().millisecondsSinceEpoch}',
      request: request,
      createdAt: DateTime.now(),
    );

    _offlineDrafts.add(draft);
    notifyListeners();
  }

  Future<void> syncOfflineDrafts() async {
    if (!_isOnline) return;

    final drafts = List<OfflineDraft>.from(_offlineDrafts);
    if (drafts.isEmpty) return;

    for (final d in drafts) {
      createRepairRequest(d.request);
    }

    _offlineDrafts.clear();
    notifyListeners();
  }

  // System config
  SystemConfig? get systemConfig => _systemConfig;
  void setSystemConfig(SystemConfig config) {
    _systemConfig = config;
    // Seed-time only logging for demo purposes.
    _auditLogs.add(
      AuditLog.create(
        adminId: 'admin_1',
        adminName: 'System Admin',
        action: AdminActionType.configChanged,
        targetType: 'systemConfig',
        targetId: config.id,
        oldValue: <String, dynamic>{},
        newValue: <String, dynamic>{'id': config.id},
        reason: 'System configuration updated',
        ipAddress: '127.0.0.1',
        reversible: false,
      ),
    );
    notifyListeners();
  }

  // Market & Bids
  List<RepairRequest> get marketRequests => List.unmodifiable(_marketRequests);
  List<Bid> get bids => List.unmodifiable(_bids);
  List<Contract> get contracts => List.unmodifiable(_contracts);

  List<RepairRequest> getPublicRequests({
    String? query,
    double? minBudget,
    double? maxBudget,
    String? location,
  }) {
    final q = query?.trim().toLowerCase();
    final loc = location?.trim().toLowerCase();

    return _marketRequests.where((r) {
      // Only show non-draft public projects
      if (r.status == RequestStatus.draft ||
          r.status == RequestStatus.cancelled) {
        return false;
      }

      if (q != null && q.isNotEmpty) {
        final inTitle = r.title.toLowerCase().contains(q);
        final inDesc = r.description.toLowerCase().contains(q);
        if (!inTitle && !inDesc) return false;
      }

      if (loc != null && loc.isNotEmpty) {
        if (!r.location.toLowerCase().contains(loc)) return false;
      }

      if (minBudget != null) {
        final rMax = r.budgetMax ?? 0;
        if (rMax < minBudget) return false;
      }

      if (maxBudget != null) {
        final rMin = r.budgetMin ?? double.infinity;
        if (rMin > maxBudget) return false;
      }

      return true;
    }).toList();
  }

  List<RepairRequest> getRequestsForOwner(String userId) {
    return _marketRequests.where((r) => r.ownerId == userId).toList();
  }

  List<Bid> getBidsForRequest(String requestId) {
    return _bids.where((b) => b.requestId == requestId).toList();
  }

  void createRepairRequest(RepairRequest request) {
    final existsIdx =
        _marketRequests.indexWhere((r) => r.id == request.id);
    if (existsIdx != -1) {
      _marketRequests[existsIdx] = request;
    } else {
      _marketRequests.add(request);
    }
    notifyListeners();
  }

  void placeBid(Bid bid) {
    final existingIdx = _bids.indexWhere((b) => b.id == bid.id);
    if (existingIdx != -1) return;

    _bids.add(bid);

    // If the request is newly posted, switch it to bidding when first bid arrives.
    final reqIdx = _marketRequests.indexWhere((r) => r.id == bid.requestId);
    if (reqIdx != -1) {
      final req = _marketRequests[reqIdx];
      if (req.status == RequestStatus.posted) {
        _marketRequests[reqIdx] = req.copyWith(
          status: RequestStatus.bidding,
        );
      }
    }

    notifyListeners();
  }

  void acceptBid(String bidId) {
    final bidIdx = _bids.indexWhere((b) => b.id == bidId);
    if (bidIdx == -1) return;

    final bid = _bids[bidIdx];
    final reqIdx = _marketRequests.indexWhere((r) => r.id == bid.requestId);
    if (reqIdx == -1) return;

    // Update bid + reject others for the same request.
    _bids[bidIdx] = bid.copyWith(status: BidStatus.accepted);
    for (var i = 0; i < _bids.length; i++) {
      if (_bids[i].requestId == bid.requestId && _bids[i].id != bidId) {
        _bids[i] = _bids[i].copyWith(status: BidStatus.rejected);
      }
    }

    // Update request status
    _marketRequests[reqIdx] = _marketRequests[reqIdx].copyWith(
      status: RequestStatus.awarded,
    );

    // Create contract if missing
    final contractId = 'contract_${bid.requestId}_$bidId';
    final existingContractIdx =
        _contracts.indexWhere((c) => c.id == contractId);

    if (existingContractIdx == -1) {
      final request = _marketRequests[reqIdx];
      _contracts.add(
        Contract(
          id: contractId,
          requestId: request.id,
          ownerId: request.ownerId,
          engineerId: bid.engineerId,
          engineerName: bid.engineerName,
          bidId: bid.id,
          agreedPrice: bid.price,
          agreedDuration: bid.durationDays,
          warrantyMonths: bid.warrantyMonths,
          methodology: bid.methodDescription,
          status: ContractStatus.active,
          createdAt: DateTime.now(),
          startedAt: DateTime.now(),
          completedAt: null,
          completionNotes: null,
          engineerMarkedComplete: false,
          ownerApproved: false,
          ownerFeedback: null,
        ),
      );
    }

    notifyListeners();
  }

  // Verifications
  List<VerificationRequest> getPendingVerifications() =>
      List.unmodifiable(
        _pendingVerifications.where(
          (r) =>
              r.status == VerificationRequestStatus.pending ||
              r.status == VerificationRequestStatus.underReview ||
              r.status == VerificationRequestStatus.documentsRequested,
        ),
      );

  void approveVerification({
    required String requestId,
    required String adminId,
    required String adminName,
    required TrustLevel trustLevel,
    String? reviewNotes,
  }) {
    final idx =
        _pendingVerifications.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;

    _pendingVerifications[idx] = _pendingVerifications[idx].copyWith(
      status: VerificationRequestStatus.approved,
      trustLevel: trustLevel,
      reviewedBy: adminName,
      reviewedAt: DateTime.now(),
      reviewNotes: reviewNotes,
      rejectionReason: null,
    );

    _auditLogs.add(
      AuditLog.create(
        adminId: adminId,
        adminName: adminName,
        action: AdminActionType.verificationApproved,
        targetType: 'verificationRequest',
        targetId: requestId,
        oldValue: <String, dynamic>{'status': 'pending'},
        newValue: <String, dynamic>{
          'status': 'approved',
          'trustLevel': trustLevel.toString(),
        },
        reason: 'Verification approved',
        ipAddress: '127.0.0.1',
        reversible: false,
      ),
    );

    notifyListeners();
  }

  void rejectVerification({
    required String requestId,
    required String adminId,
    required String adminName,
    required String rejectionReason,
  }) {
    final idx =
        _pendingVerifications.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;

    _pendingVerifications[idx] = _pendingVerifications[idx].copyWith(
      status: VerificationRequestStatus.rejected,
      trustLevel: TrustLevel.none,
      reviewedBy: adminName,
      reviewedAt: DateTime.now(),
      reviewNotes: null,
      rejectionReason: rejectionReason,
    );

    _auditLogs.add(
      AuditLog.create(
        adminId: adminId,
        adminName: adminName,
        action: AdminActionType.verificationRejected,
        targetType: 'verificationRequest',
        targetId: requestId,
        oldValue: <String, dynamic>{'status': 'pending'},
        newValue: <String, dynamic>{
          'status': 'rejected',
          'rejectionReason': rejectionReason,
        },
        reason: 'Verification rejected',
        ipAddress: '127.0.0.1',
        reversible: false,
      ),
    );

    notifyListeners();
  }

  // Contracts & Projects
  Contract? getContractById(String id) {
    final idx = _contracts.indexWhere((c) => c.id == id);
    return idx == -1 ? null : _contracts[idx];
  }

  void approveCompletion(String id) {
    final idx = _contracts.indexWhere((c) => c.id == id);
    if (idx == -1) return;

    final contract = _contracts[idx];
    if (contract.status != ContractStatus.pendingCompletion) return;

    _contracts[idx] = contract.copyWith(
      status: ContractStatus.completed,
      completedAt: DateTime.now(),
      ownerApproved: true,
    );

    notifyListeners();
  }

  void markProjectComplete(String id, [dynamic arg2]) {
    final idx = _contracts.indexWhere((c) => c.id == id);
    if (idx == -1) return;

    final notes = arg2 is String ? arg2 : arg2?.toString() ?? '';

    final contract = _contracts[idx];
    _contracts[idx] = contract.copyWith(
      status: ContractStatus.pendingCompletion,
      completionNotes: notes,
      engineerMarkedComplete: true,
      ownerApproved: false,
    );

    notifyListeners();
  }

  void requestRevisions(String id, String notes) {
    final idx = _contracts.indexWhere((c) => c.id == id);
    if (idx == -1) return;

    final contract = _contracts[idx];
    _contracts[idx] = contract.copyWith(
      status: ContractStatus.inProgress,
      engineerMarkedComplete: false,
      ownerApproved: false,
      ownerFeedback: notes,
    );

    notifyListeners();
  }

  void submitReview({
    required String contractId,
    required String reviewerId,
    required String reviewerName,
    required String revieweeId,
    required String revieweeName,
    required double rating,
    required String comment,
  }) {
    final alreadyExists = _reviews.any(
      (r) => r.contractId == contractId && r.reviewerId == reviewerId,
    );
    if (alreadyExists) return;

    _reviews.add(
      Review(
        id: 'review_${DateTime.now().millisecondsSinceEpoch}',
        contractId: contractId,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        revieweeId: revieweeId,
        revieweeName: revieweeName,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // Others
  List<Dispute> get disputes => List.unmodifiable(_disputes);

  void createDispute({
    required String contractId,
    required String raisedBy,
    required String raisedByName,
    required String reason,
    required String description,
  }) {
    final disputeId = 'dispute_${DateTime.now().millisecondsSinceEpoch}';
    _disputes.add(
      Dispute(
        id: disputeId,
        contractId: contractId,
        raisedBy: raisedBy,
        raisedByName: raisedByName,
        reason: reason,
        description: description,
        status: DisputeStatus.open,
        createdAt: DateTime.now(),
        resolvedAt: null,
        resolution: null,
      ),
    );
    notifyListeners();
  }

  void resolveDispute({
    required String disputeId,
    required String resolutionType,
    required String notes,
  }) {
    final idx = _disputes.indexWhere((d) => d.id == disputeId);
    if (idx == -1) return;

    final now = DateTime.now();
    final old = _disputes[idx];
    _disputes[idx] = old.copyWith(
      status: DisputeStatus.resolved,
      resolvedAt: now,
      resolution: '$resolutionType: ${notes.trim()}',
    );

    _auditLogs.add(
      AuditLog.create(
        adminId: 'admin_1',
        adminName: 'System Admin',
        action: AdminActionType.disputeResolved,
        targetType: 'dispute',
        targetId: disputeId,
        oldValue: <String, dynamic>{
          'status': old.status.toString(),
        },
        newValue: <String, dynamic>{
          'status': DisputeStatus.resolved.toString(),
          'resolution': old.copyWith(
            status: DisputeStatus.resolved,
            resolvedAt: now,
            resolution: '$resolutionType: ${notes.trim()}',
          ).resolution,
        },
        reason: 'Dispute resolved',
        ipAddress: '127.0.0.1',
        reversible: false,
      ),
    );

    notifyListeners();
  }
  
  List<AuditLog> get auditLogs => List.unmodifiable(_auditLogs);

  // ==================== Support Tickets ====================
  List<SupportTicket> get supportTickets => List.unmodifiable(_supportTickets);

  void resolveSupportTicket(
    String ticketId, {
    required String adminName,
    String? resolutionNote,
  }) {
    final idx = _supportTickets.indexWhere((t) => t.id == ticketId);
    if (idx == -1) return;

    final old = _supportTickets[idx];
    _supportTickets[idx] = old.copyWith(
      status: SupportTicketStatus.resolved,
      resolvedAt: DateTime.now(),
      resolutionNote: resolutionNote,
    );

    // Notify user (demo-style)
    _notifications.add(
      AppNotification(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        userId: old.userId,
        title: 'Ticket Resolved',
        body: resolutionNote?.isNotEmpty == true
            ? resolutionNote!
            : 'Your support ticket has been resolved.',
        isRead: false,
        priority: NotificationPriority.medium,
        createdAt: DateTime.now(),
      ),
    );

    _auditLogs.add(
      AuditLog.create(
        adminId: 'admin_1',
        adminName: adminName,
        action: AdminActionType.configChanged,
        targetType: 'supportTicket',
        targetId: ticketId,
        oldValue: <String, dynamic>{'status': old.status.toString()},
        newValue: <String, dynamic>{
          'status': SupportTicketStatus.resolved.toString(),
        },
        reason: 'Support ticket resolved',
        ipAddress: '127.0.0.1',
        reversible: false,
      ),
    );

    notifyListeners();
  }

  // ==================== Notifications ====================
  List<AppNotification> notificationsForUser(String userId) {
    return _notifications
        .where(
          (n) => n.userId == userId || n.userId == 'any',
        )
        .toList(growable: false);
  }

  List<AppNotification> get allNotifications => List.unmodifiable(_notifications);

  void markNotificationRead(String notificationId) {
    final idx = _notifications.indexWhere((n) => n.id == notificationId);
    if (idx == -1) return;

    final old = _notifications[idx];
    _notifications[idx] = old.copyWith(isRead: true);
    notifyListeners();
  }

  List<Review> get reviews => List.unmodifiable(_reviews);

  List<Company> getCompanies({
    String? query,
    double? minRating,
    String? location,
    bool verifiedOnly = false,
  }) {
    final q = query?.trim().toLowerCase();
    final loc = location?.trim().toLowerCase();

    return _companies.where((c) {
      if (verifiedOnly && !c.isVerified) return false;
      if (minRating != null && c.rating < minRating) return false;
      if (loc != null && loc.isNotEmpty) {
        if (!c.location.toLowerCase().contains(loc)) return false;
      }
      if (q != null && q.isNotEmpty) {
        final inName = c.name.toLowerCase().contains(q);
        final inDesc = c.description.toLowerCase().contains(q);
        if (!inName && !inDesc) return false;
      }
      return true;
    }).toList();
  }

  void _seedDummyData() {
    if (_marketRequests.isNotEmpty ||
        _pendingVerifications.isNotEmpty ||
        _companies.isNotEmpty) {
      return;
    }

    final now = DateTime.now();

    _systemConfig = SystemConfig(
      id: 'config_1',
      lastUpdatedAt: now,
      lastUpdatedBy: 'System',
    );

    _companies.add(
      Company.createDummy(
        name: 'SafeBuild Engineering',
        description:
            'Structural repair and safety assessment services.',
        location: 'Cairo, Egypt',
        rating: 4.8,
        verified: true,
      ),
    );

    _pendingVerifications.add(
      VerificationRequest(
        id: 'ver_1',
        userId: 'user_eng_1',
        userRole: 'engineer',
        syndicateNumber: '12345',
        yearsOfExperience: 3,
        status: VerificationRequestStatus.pending,
        trustLevel: TrustLevel.junior,
        submittedAt: now.subtract(const Duration(days: 2)),
      ),
    );

    final request = RepairRequest(
      id: 'req_1',
      ownerId: 'user_owner_1',
      title: 'Structural repair for residential building',
      description:
          'Cracks detected in walls. Need structural assessment and repair.',
      images: const [],
      location: 'Cairo, Egypt',
      status: RequestStatus.bidding,
      budgetMin: 10000,
      budgetMax: 50000,
      riskLevel: RiskLevel.high,
      aiReportId: null,
      createdAt: now.subtract(const Duration(days: 5)),
      biddingEndsAt: now.add(const Duration(days: 3)),
      completedAt: null,
    );
    _marketRequests.add(request);

    _bids.addAll([
      Bid(
        id: 'bid_1',
        requestId: request.id,
        engineerId: 'user_eng_1',
        engineerName: 'Engineer Ahmed',
        price: 30000,
        durationDays: 30,
        proposal:
            'We will perform structural reinforcement and crack repair.',
        warrantyMonths: 12,
        methodDescription: 'Epoxy injection + reinforcement.',
        status: BidStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Bid(
        id: 'bid_2',
        requestId: request.id,
        engineerId: 'user_eng_2',
        engineerName: 'Engineer Sara',
        price: 35000,
        durationDays: 45,
        proposal: 'Comprehensive repair including stabilization.',
        warrantyMonths: 10,
        methodDescription: 'Repointing + curing + sealing.',
        status: BidStatus.pending,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
    ]);

    _auditLogs.add(
      AuditLog.create(
        adminId: 'admin_1',
        adminName: 'System Admin',
        action: AdminActionType.configChanged,
        targetType: 'systemConfig',
        targetId: 'config_1',
        oldValue: <String, dynamic>{},
        newValue: <String, dynamic>{'seeded': true},
        reason: 'Seed dummy data',
        ipAddress: '127.0.0.1',
        reversible: false,
      ),
    );

    _supportTickets.add(
      SupportTicket(
        id: 'ticket_1',
        userId: 'any',
        userName: 'Demo User',
        subject: 'Unable to upload documents',
        description: 'The app shows an error when uploading images.',
        status: SupportTicketStatus.open,
        priority: NotificationPriority.high,
        createdAt: now.subtract(const Duration(hours: 10)),
      ),
    );

    _notifications.add(
      AppNotification(
        id: 'notif_1',
        userId: 'any',
        title: 'Welcome to CrackDetectX',
        body: 'Your account is ready. Use Scan to start.',
        isRead: false,
        priority: NotificationPriority.medium,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    );
  }

  // ==================== Role Management ====================

  /// Sets current user role and persists it locally
  Future<void> setUserRole(UserRole role) async {
    _currentUserRole = role;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userRoleStorageKey, role.name);
  }

  // ==================== Buildings CRUD ====================

  void addBuilding(Building building) {
    _buildings.add(building);
    notifyListeners();
    _saveBuildings();
  }

  void removeBuilding(String id) {
    _buildings.removeWhere((b) => b.id == id);
    notifyListeners();
    _saveBuildings();
  }

  void updateBuilding(Building updated) {
    final idx = _buildings.indexWhere((b) => b.id == updated.id);
    if (idx != -1) {
      _buildings[idx] = updated;
      notifyListeners();
      _saveBuildings();
    }
  }

  // ==================== Projects CRUD ====================

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
    _saveProjects();
  }

  void removeProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();
    _saveProjects();
  }

  // ==================== Annotations CRUD ====================

  void addAnnotation(Annotation annotation) {
    _annotations.add(annotation);
    notifyListeners();
    _saveAnnotations();
  }

  // ==================== Persistence ====================

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load user role
    final roleStr = prefs.getString(AppConstants.userRoleStorageKey);
    if (roleStr != null) {
      _currentUserRole = UserRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserRole.engineer,
      );
    }

    // Load buildings
    final buildingsJson = prefs.getStringList(AppConstants.buildingsStorageKey) ?? [];
    _buildings.clear();
    for (final raw in buildingsJson) {
      try {
        _buildings.add(Building.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {}
    }

    // Load projects
    final projectsJson = prefs.getStringList(AppConstants.projectsStorageKey) ?? [];
    _projects.clear();
    for (final raw in projectsJson) {
      try {
        _projects.add(Project.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {}
    }

    // Load annotations
    final annotationsJson = prefs.getStringList(AppConstants.annotationsStorageKey) ?? [];
    _annotations.clear();
    for (final raw in annotationsJson) {
      try {
        _annotations.add(Annotation.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {}
    }

    notifyListeners();
  }

  Future<void> _saveBuildings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.buildingsStorageKey,
      _buildings.map((b) => jsonEncode(b.toJson())).toList(),
    );
  }

  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.projectsStorageKey,
      _projects.map((p) => jsonEncode(p.toJson())).toList(),
    );
  }

  Future<void> _saveAnnotations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppConstants.annotationsStorageKey,
      _annotations.map((a) => jsonEncode(a.toJson())).toList(),
    );
  }
}
