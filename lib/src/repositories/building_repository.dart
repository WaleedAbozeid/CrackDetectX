import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/building_models.dart';

/// Repository for Building CRUD operations via the backend API.
///
/// Endpoints used:
/// - `GET    /buildings`           — list user's buildings
/// - `POST   /buildings`           — create building
/// - `GET    /buildings/{id}`      — get single building
/// - `PUT    /buildings/{id}`      — update building
/// - `DELETE /buildings/{id}`      — delete building
class BuildingRepository {
  BuildingRepository._();
  static final BuildingRepository instance = BuildingRepository._();

  final ApiClient _client = ApiClient.instance;

  // ─── GET /buildings ────────────────────────────────────────────────────

  /// Returns all buildings owned by the authenticated user.
  Future<List<Building>> getBuildings() async {
    try {
      final response = await _client.get('/buildings');
      final raw = response.data;

      List<dynamic> list;
      if (raw is Map && raw['data'] is List) {
        list = raw['data'] as List;
      } else if (raw is List) {
        list = raw;
      } else {
        list = [];
      }

      return list
          .map((e) => Building.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── GET /buildings/{id} ──────────────────────────────────────────────

  Future<Building> getBuildingById(String id) async {
    try {
      final response = await _client.get('/buildings/$id');
      final data = (response.data['data'] ?? response.data) as Map<String, dynamic>;
      return Building.fromJson(data);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── POST /buildings ───────────────────────────────────────────────────

  /// Creates a new building and returns the server-assigned model.
  Future<Building> createBuilding({
    required String name,
    required String address,
    int? yearBuilt,
    String? projectId,
  }) async {
    try {
      final response = await _client.post('/buildings', data: {
        'name': name.trim(),
        'address': address.trim(),
        'year_built': yearBuilt,
        'project_id': projectId,
      });
      final data = (response.data['data'] ?? response.data) as Map<String, dynamic>;
      return Building.fromJson(data);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── PUT /buildings/{id} ──────────────────────────────────────────────

  Future<Building> updateBuilding(Building building) async {
    try {
      final response = await _client.put(
        '/buildings/${building.id}',
        data: {
        'name': building.name,
        'address': building.address,
        'year_built': building.yearBuilt,
        'project_id': building.projectId,
        },
      );
      final data = (response.data['data'] ?? response.data) as Map<String, dynamic>;
      return Building.fromJson(data);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── DELETE /buildings/{id} ───────────────────────────────────────────

  Future<void> deleteBuilding(String id) async {
    try {
      await _client.delete('/buildings/$id');
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }
}
