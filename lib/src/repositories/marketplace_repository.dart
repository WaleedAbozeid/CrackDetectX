import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/marketplace_models.dart';

/// Repository for Marketplace operations (Requests, Bids, Contracts).
///
/// Endpoints used (from Postman collection):
/// - `GET    /marketplace/requests`          — browse all public requests
/// - `POST   /marketplace/requests`          — create a new repair request
/// - `GET    /marketplace/requests/{id}`     — get request details + bids
/// - `GET    /marketplace/requests/my`       — owner's own requests
/// - `POST   /marketplace/requests/{id}/bids` — submit a bid
/// - `POST   /marketplace/bids/{id}/accept`  — accept a bid (owner)
/// - `GET    /marketplace/contracts`         — list user's contracts
/// - `GET    /marketplace/contracts/{id}`    — contract details
/// - `GET    /marketplace/engineers`         — browse available engineers/companies
class MarketplaceRepository {
  MarketplaceRepository._();
  static final MarketplaceRepository instance = MarketplaceRepository._();

  final ApiClient _client = ApiClient.instance;

  // ─── Requests ──────────────────────────────────────────────────────────

  /// Fetches all public/available repair requests.
  ///
  /// Used by Repair Companies browsing for projects to bid on.
  Future<List<RepairRequest>> getRequests({
    String? status,
    String? location,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (location != null) queryParams['location'] = location;

      final response = await _client.get(
        '/marketplace/requests',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['requests'] ?? []) as List<dynamic>;

      return list
          .map((e) => RepairRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  /// Fetches the current owner's own repair requests.
  Future<List<RepairRequest>> getMyRequests() async {
    try {
      final response = await _client.get('/marketplace/requests/my');
      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['requests'] ?? []) as List<dynamic>;

      return list
          .map((e) => RepairRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  /// Fetches a single request with its bids.
  Future<RepairRequest> getRequest(String requestId) async {
    try {
      final response = await _client.get('/marketplace/requests/$requestId');
      return RepairRequest.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  /// Creates a new repair request (Building Owner).
  ///
  /// Returns the newly created [RepairRequest] with server-assigned id.
  Future<RepairRequest> createRequest({
    required String title,
    required String description,
    required String location,
    double? budgetMin,
    double? budgetMax,
    String? aiReportId,
    String? riskLevel,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title.trim(),
        'description': description.trim(),
        'location': location.trim(),
      };
      if (budgetMin != null) body['budget_min'] = budgetMin;
      if (budgetMax != null) body['budget_max'] = budgetMax;
      if (aiReportId != null) body['ai_report_id'] = aiReportId;
      if (riskLevel != null) body['risk_level'] = riskLevel;

      final response = await _client.post('/marketplace/requests', data: body);
      return RepairRequest.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Bids ──────────────────────────────────────────────────────────────

  /// Submits a bid on a repair request (Repair Company).
  Future<Bid> submitBid({
    required String requestId,
    required double price,
    required int durationDays,
    required String proposal,
    int warrantyMonths = 0,
    String? methodDescription,
  }) async {
    try {
      final response = await _client.post(
        '/marketplace/requests/$requestId/bids',
        data: {
          'price': price,
          'duration_days': durationDays,
          'proposal': proposal.trim(),
          'warranty_months': warrantyMonths,
          if (methodDescription != null)
            'method_description': methodDescription.trim(),
        },
      );
      return Bid.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  /// Accepts a bid — only Building Owner can call this.
  ///
  /// On success, the backend generates a [Contract] automatically.
  Future<Contract> acceptBid(String bidId) async {
    try {
      final response = await _client.post('/marketplace/bids/$bidId/accept');
      // Backend returns the new contract
      return Contract.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Contracts ─────────────────────────────────────────────────────────

  /// Lists all contracts for the current user.
  Future<List<Contract>> getContracts() async {
    try {
      final response = await _client.get('/marketplace/contracts');
      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['contracts'] ?? []) as List<dynamic>;

      return list
          .map((e) => Contract.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  /// Gets a single contract by id.
  Future<Contract> getContract(String contractId) async {
    try {
      final response =
          await _client.get('/marketplace/contracts/$contractId');
      return Contract.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }

  // ─── Engineers / Companies ─────────────────────────────────────────────

  /// Fetches available repair companies/engineers for owner to browse.
  Future<List<Company>> getEngineers({String? specialty}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (specialty != null) queryParams['specialty'] = specialty;

      final response = await _client.get(
        '/marketplace/engineers',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final data = response.data;
      final List<dynamic> list = data is List
          ? data
          : (data['data'] ?? data['engineers'] ?? []) as List<dynamic>;

      return list
          .map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.apiException ?? ApiException.network();
    }
  }
}
