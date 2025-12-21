import 'package:flutter/material.dart';
import '../ai/types.dart';
import '../models/todo.dart';
import '../models/marketplace_models.dart';

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
  final List<RepairRequest> _marketRequests = [];
  final List<Bid> _bids = [];
  final List<Company> _companies = [
    Company.createDummy(
      name: 'Benaa Engineering',
      description:
          'Leading structural engineering firm specializing in crack analysis and building safety assessments.',
      location: 'Cairo',
      rating: 4.8,
      verified: true,
    ),
    Company.createDummy(
      name: 'SafeHome Solutions',
      description:
          'Professional home inspection services with AI-powered tools.',
      location: 'Giza',
      rating: 4.5,
      verified: true,
    ),
    Company.createDummy(
      name: 'Alex Build',
      description: 'General contracting and maintenance services.',
      location: 'Alexandria',
      rating: 4.2,
      verified: false,
    ),
  ];

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

  // ==================== Theme & Locale ====================
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar'); // Default to Arabic

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'ar') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('ar');
    }
    notifyListeners();
  }

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

  // ==================== Marketplace Management ====================

  List<RepairRequest> get marketRequests => List.unmodifiable(_marketRequests);
  List<Bid> get bids => List.unmodifiable(_bids);

  /// Create a new repair request
  void createRepairRequest(RepairRequest request) {
    _marketRequests.add(request);
    notifyListeners();
  }

  /// Get requests for a specific owner
  List<RepairRequest> getRequestsForOwner(String ownerId) {
    return _marketRequests.where((r) => r.ownerId == ownerId).toList();
  }

  /// Get public requests (posted) with optional filtering
  List<RepairRequest> getPublicRequests({
    String? query,
    double? minBudget,
    double? maxBudget,
    String? location,
  }) {
    return _marketRequests.where((r) {
      if (r.status != RequestStatus.posted) return false;

      // Filter by query (title or description)
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matches =
            r.title.toLowerCase().contains(q) ||
            r.description.toLowerCase().contains(q);
        if (!matches) return false;
      }

      // Filter by Budget
      // If request has budgetMin/Max, check overlap with filter min/max
      if (minBudget != null &&
          r.budgetMax != null &&
          r.budgetMax! < minBudget) {
        return false;
      }
      if (maxBudget != null &&
          r.budgetMin != null &&
          r.budgetMin! > maxBudget) {
        return false;
      }

      // Filter by Location
      if (location != null &&
          location.isNotEmpty &&
          !r.location.toLowerCase().contains(location.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get companies with optional filtering
  List<Company> getCompanies({
    String? query,
    double? minRating,
    String? location,
    bool? verifiedOnly,
  }) {
    return _companies.where((c) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!c.name.toLowerCase().contains(q) &&
            !c.description.toLowerCase().contains(q)) {
          return false;
        }
      }

      if (minRating != null && c.rating < minRating) return false;

      if (location != null &&
          location.isNotEmpty &&
          !c.location.toLowerCase().contains(location.toLowerCase())) {
        return false;
      }

      if (verifiedOnly == true && !c.isVerified) return false;

      return true;
    }).toList();
  }

  /// Place a bid
  void placeBid(Bid bid) {
    _bids.add(bid);

    // Update request status to 'bidding' if it was 'posted'
    final requestIndex = _marketRequests.indexWhere(
      (r) => r.id == bid.requestId,
    );
    if (requestIndex != -1) {
      final request = _marketRequests[requestIndex];
      if (request.status == RequestStatus.posted) {
        _marketRequests[requestIndex] = request.copyWith(
          status: RequestStatus.bidding,
        );
      }
    }
    notifyListeners();
  }

  /// Get bids for a specific request
  List<Bid> getBidsForRequest(String requestId) {
    return _bids.where((b) => b.requestId == requestId).toList();
  }

  /// Accept a bid
  void acceptBid(String bidId) {
    final bidIndex = _bids.indexWhere((b) => b.id == bidId);
    if (bidIndex == -1) return;

    final bid = _bids[bidIndex];
    final requestId = bid.requestId;

    // Update bid status
    _bids[bidIndex] = bid.copyWith(status: BidStatus.accepted);

    // Update other bids for this request to rejected
    for (var i = 0; i < _bids.length; i++) {
      if (_bids[i].requestId == requestId && _bids[i].id != bidId) {
        _bids[i] = _bids[i].copyWith(status: BidStatus.rejected);
      }
    }

    // Update request status to awarded
    final requestIndex = _marketRequests.indexWhere((r) => r.id == requestId);
    if (requestIndex != -1) {
      _marketRequests[requestIndex] = _marketRequests[requestIndex].copyWith(
        status: RequestStatus.awarded,
      );
    }

    notifyListeners();
  }
}
