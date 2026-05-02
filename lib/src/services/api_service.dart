import '../ai/model_stub.dart';
import '../ai/types.dart';
import '../models/building_models.dart';
import '../services/local_db.dart';

/// Centralized API service for all backend communication.
///
/// Currently delegates to local stubs and SharedPreferences storage.
/// When the backend is ready, replace each method body with the
/// corresponding HTTP call — the rest of the app stays unchanged.
///
/// Base URL (update when backend is live):
/// ```
/// static const baseUrl = 'https://api.crackdetectx.com/v1';
/// ```
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  // TODO: Replace with real backend URL when ready
  static const String baseUrl = 'http://localhost:8000/api/v1';

  // ==================== AI Detection ====================

  /// Analyzes an image for cracks.
  /// [imagePath] — local file path.
  /// [buildingId] — optional building FK for linking.
  ///
  /// TODO: Replace with:
  /// ```
  /// POST $baseUrl/scans
  /// { "imageUrl": uploadedUrl, "buildingId": buildingId }
  /// Response: { "scanId": ..., "status": "queued" }
  /// ```
  Future<DetectionResult> analyzeImage(
    String imagePath, {
    String? buildingId,
  }) async {
    return processImageStub(imagePath);
  }

  // ==================== Reports ====================

  /// Fetches all reports for the current user.
  ///
  /// TODO: Replace with:
  /// ```
  /// GET $baseUrl/reports
  /// Headers: { Authorization: Bearer <token> }
  /// ```
  Future<List<Report>> getReports() async {
    return LocalDb.instance.loadReports();
  }

  /// Saves a report locally (and will sync to backend).
  ///
  /// TODO: Replace with:
  /// ```
  /// POST $baseUrl/reports
  /// Body: report.toJson()
  /// ```
  Future<void> saveReport(Report report) async {
    await LocalDb.instance.saveReport(report);
  }

  /// Deletes a report by id.
  ///
  /// TODO: Replace with:
  /// ```
  /// DELETE $baseUrl/reports/:id
  /// ```
  Future<void> deleteReport(String id) async {
    await LocalDb.instance.deleteReport(id);
  }

  // ==================== Buildings ====================

  /// Fetches buildings from backend.
  ///
  /// TODO: Replace with:
  /// ```
  /// GET $baseUrl/buildings
  /// ```
  Future<List<Building>> getBuildings() async {
    // Local state (AppState) handles buildings for now
    return [];
  }

  /// Saves a building to backend.
  ///
  /// TODO: Replace with:
  /// ```
  /// POST $baseUrl/buildings
  /// Body: building.toJson()
  /// ```
  Future<void> saveBuilding(Building building) async {
    // Local state handles persistence — no-op until backend ready
  }

  // ==================== Annotations ====================

  /// Saves an annotation for a scan.
  ///
  /// TODO: Replace with:
  /// ```
  /// POST $baseUrl/scans/:scanId/annotate
  /// Body: annotation.toJson()
  /// ```
  Future<void> saveAnnotation(Annotation annotation) async {
    // Local state handles this — no-op until backend ready
  }
}
