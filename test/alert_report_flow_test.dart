import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// localization imports removed for tests
import 'package:hive/hive.dart';

import 'package:mat_sjekk/widgets.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    // initialize temp hive directory for tests
    try {
      // Put a timeout on box opening to fail fast if something blocks
      await Hive.openBox('alerts_feedback').timeout(const Duration(seconds: 30));
    } catch (e) {
      rethrow;
    }
  });

  tearDownAll(() async {
    try {
      await Hive.box('alerts_feedback').clear();
      await Hive.box('alerts_feedback').close();
    } catch (_) {}
    // On some Windows environments the test harness may fail to delete
    // ephemeral listener files. Avoid deleting the temp dir here to
    // prevent finalization errors in the test runner.
  });

  testWidgets('Alert -> Report persists feedback in Hive', (WidgetTester tester) async {
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
        MaterialApp(home: Scaffold(body: ProductInfoDialogContent(info: sampleInfo, onAddItem: (_) {}))),
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
      await tester.enterText(textFieldFinder.first, 'Test report from widget test');
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
  });
}
