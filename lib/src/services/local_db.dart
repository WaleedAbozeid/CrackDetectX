import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../ai/types.dart';
import '../core/constants.dart';

/// Local database service for persisting reports
/// 
/// Currently uses SharedPreferences for storage.
/// Can be replaced with Hive or SQLite for better performance in production.
class LocalDb {
  LocalDb._(); // Private constructor

  static final LocalDb instance = LocalDb._();

  /// Saves a report to local storage
  /// 
  /// [report] - The report to save
  /// Throws [Exception] if save operation fails
  Future<void> saveReport(Report report) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reports = await loadReports();
      
      // Check if report with same ID already exists
      final existingIndex = reports.indexWhere((r) => r.id == report.id);
      if (existingIndex != -1) {
        reports[existingIndex] = report; // Update existing
      } else {
        reports.add(report); // Add new
      }

      // Convert reports to JSON and save
      final reportsJson = reports.map((r) => r.toJson()).toList();
      await prefs.setString(
        AppConstants.reportsStorageKey,
        jsonEncode(reportsJson),
      );
    } catch (e) {
      throw Exception('${AppConstants.errorReportSaveFailed}: $e');
    }
  }

  /// Loads all reports from local storage
  /// 
  /// Returns a list of reports, empty list if none found
  /// Throws [Exception] if load operation fails
  Future<List<Report>> loadReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString(AppConstants.reportsStorageKey);

      if (reportsJson == null || reportsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(reportsJson);
      return decoded.map((json) => Report.fromJson(json)).toList();
    } catch (e) {
      throw Exception('${AppConstants.errorReportLoadFailed}: $e');
    }
  }

  /// Deletes a report by ID
  /// 
  /// [id] - The ID of the report to delete
  /// Returns true if deleted, false if not found
  /// Throws [Exception] if delete operation fails
  Future<bool> deleteReport(String id) async {
    try {
      final reports = await loadReports();
      final initialLength = reports.length;
      reports.removeWhere((report) => report.id == id);

      if (reports.length < initialLength) {
        // Save updated list
        final prefs = await SharedPreferences.getInstance();
        final reportsJson = reports.map((r) => r.toJson()).toList();
        await prefs.setString(
          AppConstants.reportsStorageKey,
          jsonEncode(reportsJson),
        );
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('${AppConstants.errorReportSaveFailed}: $e');
    }
  }

  /// Clears all reports from storage
  /// 
  /// Throws [Exception] if clear operation fails
  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.reportsStorageKey);
    } catch (e) {
      throw Exception('${AppConstants.errorReportSaveFailed}: $e');
    }
  }

  /// Gets a report by ID
  /// 
  /// [id] - The ID of the report to retrieve
  /// Returns the report if found, null otherwise
  Future<Report?> getReportById(String id) async {
    try {
      final reports = await loadReports();
      try {
        return reports.firstWhere((report) => report.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
