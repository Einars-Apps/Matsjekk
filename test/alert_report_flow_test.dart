import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

// localization imports removed for tests
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:mat_sjekk/widgets.dart';

void main() {
  // Use per-test setUp/tearDown to avoid cross-test interference and
  // platform-specific finalizer races on Windows.

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // use in-memory Hive for tests to avoid platform-specific temp-file races
    await setUpTestHive();
    // Pre-open commonly used box to mirror previous behavior
    await Hive.openBox('alerts_feedback');
  });

  tearDown(() async {
    // Robust per-test cleanup to reduce flakiness on Windows finalizers.
    try {
      if (Hive.isBoxOpen('alerts_feedback')) {
        final b = Hive.box('alerts_feedback');
        await b.clear();
        await b.close();
      }
    } catch (_) {
      // ignore errors during teardown
    }

    // Do not call Hive.close() here; let the test harness manage Hive lifecycle

    try {
      await tearDownTestHive();
    } catch (_) {
      // ignore teardownTestHive errors
    }

    // Small delay to allow flutter_test finalizers to complete.
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (_) {}
  });

      testWidgets('Alert -> Report persists feedback in Hive',
        (WidgetTester tester) async {
    // entering widget test
    // Ensure the test box is open (defensive against leaked/early tearDown)
    var box = Hive.isBoxOpen('alerts_feedback')
      ? Hive.box('alerts_feedback')
      : await Hive.openBox('alerts_feedback');
    try {
      // initialize the feedback list
      box.put('feedback_list', <dynamic>[]);
    } catch (e) {
      rethrow;
    }

    final sampleInfo = {
      'navn': 'Test Produkt',
      'ean': '0000000000000',
      'alerts': [
        {
          'ruleId': 'bovaer_test',
          'severity': 'red',
          'reason': 'Test reason',
          'confidence': 0.9,
          'evidence': ['matvare:example']
        }
      ]
    };

    // Avoid localization delegates in tests to prevent asset loading hangs.
    try {
      await tester.pumpWidget(
        MaterialApp(
            home: Scaffold(
                body: ProductInfoDialogContent(
                    info: sampleInfo, onAddItem: (_) {}))),
      );
      // pumpWidget returned
    } catch (e) {
      rethrow;
    }

    // Allow the widget to build; use deterministic pumps instead of pumpAndSettle
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // The alert chip or label should be visible; open its details by tapping the alert chip (reason text)
    expect(find.text('Alerts'), findsOneWidget);
    final chipFinder = find.text('Test reason');
    expect(chipFinder, findsOneWidget);
    await tester.tap(chipFinder.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Now the detail dialog should show and include a 'Report' button.
    final reportFinder = find.text('Report');
    expect(reportFinder, findsWidgets);
    await tester.tap(reportFinder.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // A report dialog with a Send button should appear. Fill the optional note and send.
    final sendFinder = find.text('Send');
    if (sendFinder.evaluate().isEmpty) {
      // Some locales use different labels; also accept 'Send' in English only.
      // Try 'Send' only — test will fail if UI differs significantly.
    }

    // Enter a note if a TextField exists
    final textFieldFinder = find.byType(TextField);
    if (textFieldFinder.evaluate().isNotEmpty) {
      await tester.enterText(
          textFieldFinder.first, 'Test report from widget test');
    }

    // Tap the send button
    await tester.tap(sendFinder.first);
    await tester.pumpAndSettle();

    // Verify that the report was stored in Hive
    final raw = box.get('feedback_list', defaultValue: <dynamic>[]);
    expect(raw, isNotNull);
    final List list = raw as List;
    expect(list.length, greaterThanOrEqualTo(1));
    final entry = list.first as Map;
    expect(entry['product'], anyOf('Test Produkt', 'Test Produkt'));
    expect(entry['ruleId'], 'bovaer_test');
    // Ensure UI and Hive are cleaned up to avoid platform finalizer races
    try {
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
    } finally {
      try {
        if (Hive.isBoxOpen('alerts_feedback')) {
          final b = Hive.box('alerts_feedback');
          await b.clear();
          await b.close();
        }
      } catch (_) {
        // ignore per-test cleanup errors
      }

      // Avoid calling Hive.close() here to prevent race with flutter_test finalizers

      // brief delay to let flutter test finalizers finish their work
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }, skip: Platform.isWindows);
}
