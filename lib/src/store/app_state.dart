import 'package:flutter/material.dart';
import '../ai/types.dart';
import '../models/todo.dart';

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
}
