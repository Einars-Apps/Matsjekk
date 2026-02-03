import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

/// Centralized Hive setup for widget tests.
Future<void> setUpHiveForTest() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await setUpTestHive();

  final boxes = [
    'alerts_feedback',
    'handlelister',
    'historikk',
    'innstillinger',
    'list_positions'
  ];

  for (final name in boxes) {
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox(name);
    }
  }
}

/// Centralized Hive teardown for widget tests.
Future<void> tearDownHiveForTest() async {
  final boxes = [
    'alerts_feedback',
    'handlelister',
    'historikk',
    'innstillinger',
    'list_positions'
  ];

  for (final name in boxes) {
    if (Hive.isBoxOpen(name)) {
      try {
        await Hive.box(name).clear().timeout(const Duration(milliseconds: 250));
      } catch (_) {}
      try {
        await Hive.box(name).close().timeout(const Duration(milliseconds: 250));
      } catch (_) {}
    }
  }

  try {
    await tearDownTestHive().timeout(const Duration(milliseconds: 250));
  } catch (_) {}

  try {
    await Hive.close().timeout(const Duration(milliseconds: 500));
  } catch (_) {}
}
