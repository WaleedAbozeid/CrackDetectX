import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crackdetectx/src/store/app_state.dart';
import 'package:crackdetectx/src/models/marketplace_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('offline draft is queued and synced when back online', () async {
    final appState = AppState();
    // Let _loadPersistedData settle before operating
    await Future<void>.delayed(Duration.zero);

    const ownerId = 'offline_owner_test_1';
    const requestId = 'offline_request_test_1';
    final request = RepairRequest(
      id: requestId,
      ownerId: ownerId,
      title: 'Offline listing test',
      description: 'Should be synced when back online',
      images: const [],
      location: 'Cairo, Egypt',
      status: RequestStatus.posted,
      budgetMin: 100,
      budgetMax: 200,
      riskLevel: RiskLevel.low,
      aiReportId: 'ai_1',
      createdAt: DateTime.now(),
      biddingEndsAt: DateTime.now().add(const Duration(days: 7)),
    );

    appState.setOnline(false);
    appState.saveOfflineDraft(request);

    expect(appState.offlineDrafts.length, 1);
    expect(
      appState.getRequestsForOwner(ownerId).any((r) => r.id == requestId),
      isFalse,
    );

    appState.setOnline(true);
    await Future<void>.delayed(Duration.zero);

    expect(appState.offlineDrafts, isEmpty);
    expect(
      appState.getRequestsForOwner(ownerId).any((r) => r.id == requestId),
      isTrue,
    );
  });

  test('sync does nothing when offline', () async {
    final appState = AppState();
    // Let _loadPersistedData settle before operating
    await Future<void>.delayed(Duration.zero);

    const ownerId = 'offline_owner_test_2';
    const requestId = 'offline_request_test_2';
    final request = RepairRequest(
      id: requestId,
      ownerId: ownerId,
      title: 'Offline sync noop test',
      description: 'Should remain queued while offline',
      images: const [],
      location: 'Cairo, Egypt',
      status: RequestStatus.posted,
      budgetMin: 50,
      budgetMax: 150,
      riskLevel: RiskLevel.medium,
      aiReportId: 'ai_2',
      createdAt: DateTime.now(),
      biddingEndsAt: DateTime.now().add(const Duration(days: 14)),
    );

    appState.setOnline(false);
    appState.saveOfflineDraft(request);

    await appState.syncOfflineDrafts();

    expect(appState.offlineDrafts.length, 1);
    expect(
      appState.getRequestsForOwner(ownerId).any((r) => r.id == requestId),
      isFalse,
    );
  });
}
