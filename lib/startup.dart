import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initializeAppDependencies({
  Future<void> Function()? initializeHive,
  Future<void> Function()? initializeAds,
}) async {
  final futures = <Future<void>>[];

  if (initializeHive != null) {
    futures.add(() async {
      await Hive.initFlutter();
      await Hive.openBox('handlelister');
      await Hive.openBox('historikk');
      await Hive.openBox('innstillinger');
      await Hive.openBox('list_positions');
    }());
  }

  if (initializeAds != null) {
    futures.add(() async {
      try {
        await initializeAds();
      } catch (e, stack) {
        debugPrint('Failed to initialize ads: $e');
        debugPrintStack(stackTrace: stack);
      }
    }());
  }

  await Future.wait(futures);
}

Future<void> initializeScannerController({
  Future<void> Function()? initializeController,
}) async {
  if (initializeController == null) {
    return;
  }
  try {
    await initializeController();
  } catch (e, stack) {
    debugPrint('Failed to initialize scanner controller: $e');
    debugPrintStack(stackTrace: stack);
  }
}
