import 'package:flutter/material.dart';
import '../ai/types.dart';
import '../models/todo.dart';

class AppState extends ChangeNotifier {
  String? _selectedImagePath;
  DetectionResult? _detectionResult;
  final List<Report> _reports = [];
  final List<Todo> _todos = [];

  String? get selectedImagePath => _selectedImagePath;
  DetectionResult? get detectionResult => _detectionResult;
  List<Report> get reports => List.unmodifiable(_reports);
  List<Todo> get todos => List.unmodifiable(_todos);
  List<Todo> get activeTodos => _todos.where((t) => !t.isCompleted).toList();
  List<Todo> get completedTodos => _todos.where((t) => t.isCompleted).toList();

  void setSelectedImage(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void setDetectionResult(DetectionResult result) {
    _detectionResult = result;
    notifyListeners();
  }

  void addReport(Report report) {
    _reports.add(report);
    notifyListeners();
  }

  void removeReport(String id) {
    _reports.removeWhere((report) => report.id == id);
    notifyListeners();
  }

  void clearReports() {
    _reports.clear();
    notifyListeners();
  }

  void clearSelection() {
    _selectedImagePath = null;
    _detectionResult = null;
    notifyListeners();
  }

  // Todo-related methods
  void addTodo(String title, String description) {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    _todos.add(todo);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = _todos[index];
      _todos[index] = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearCompletedTodos() {
    _todos.removeWhere((t) => t.isCompleted);
    notifyListeners();
  }
}
