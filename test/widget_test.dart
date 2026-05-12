// Widget smoke test for CrackDetectX.
//
// Verifies that the app starts without crashing and that the Splash screen
// renders its key elements correctly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crackdetectx/main.dart';

void main() {
  setUp(() {
    // No saved tokens → restoreSession will find nothing → onboarding.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'Splash screen renders app name and loading indicator',
    (WidgetTester tester) async {
      // Set a realistic phone screen size to prevent overflow assertions.
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Build the app — only the Splash screen renders initially.
      await tester.pumpWidget(const MyApp());
      await tester.pump(); // one frame: Splash is visible

      // ── Splash assertions ──────────────────────────────────────────────
      expect(find.text('CrackDetectX'), findsOneWidget,
          reason: 'Splash should show app name');
      expect(find.byType(CircularProgressIndicator), findsOneWidget,
          reason: 'Splash should show loading indicator');

      // Allow the 2-second timer + session restore to complete cleanly.
      // This prevents "A Timer is still pending" assertion failures.
      await tester.pumpAndSettle(const Duration(seconds: 5));
    },
  );
}
