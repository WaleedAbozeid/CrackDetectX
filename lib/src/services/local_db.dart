// Simple local DB shim. Replace implementation with `shared_preferences` or `hive` when ready.
import '../ai/types.dart';

class LocalDb {
  // In-memory store for demo; this should persist to disk in production.
  final List<Report> _storage = [];

  Future<void> saveReport(Report report) async {
    _storage.add(report);
  }

  Future<List<Report>> loadReports() async {
    return List.unmodifiable(_storage);
  }

  Future<void> clear() async {
    _storage.clear();
  }
}
