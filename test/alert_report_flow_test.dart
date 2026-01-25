import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// localization imports removed for tests
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:mat_sjekk/widgets.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Give flutter test finalizers a short moment before tearing down test hive
    try {
      await Future.delayed(const Duration(seconds: 1));
    } catch (_) {}

    // Tear down in-memory hive
    try {
      await tearDownTestHive();
      print('tearDownAll: tearDownTestHive completed');
    } catch (e, st) {
      print('tearDownAll: error in tearDownTestHive: $e');
      print(st);
    }
    try {
      if (Hive.isBoxOpen('alerts_feedback')) {
        print('tearDownAll: clearing alerts_feedback');
        final box = Hive.box('alerts_feedback');
        await box.clear();
        await box.close();
        print('tearDownAll: alerts_feedback closed');
      }
    } catch (e, st) {
      print('tearDownAll: error closing alerts_feedback: $e');
      print(st);
    }

    // Rely on `Hive.close()` below to close any remaining open boxes.

    try {
      print('tearDownAll: calling Hive.close()');
      await Hive.close();
    } catch (e, st) {
      print('tearDownAll: Hive.close() error: $e');
      print(st);
    }

    // Tear down in-memory hive
    try {
      await tearDownTestHive();
      print('tearDownAll: tearDownTestHive completed');
    } catch (e, st) {
      print('tearDownAll: error in tearDownTestHive: $e');
      print(st);
    }

    print('tearDownAll: done');
  });

  testWidgets('Alert -> Report persists feedback in Hive',
      (WidgetTester tester) async {
    // entering widget test
    final box = Hive.box('alerts_feedback');
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
      } catch (e, st) {
        print('per-test cleanup: error closing alerts_feedback: $e');
        print(st);
      }

      try {
        await Hive.close();
      } catch (e, st) {
        print('per-test cleanup: Hive.close() error: $e');
        print(st);
      }

      // brief delay to let flutter test finalizers finish their work
      await Future.delayed(const Duration(milliseconds: 750));
    }
  });
}
