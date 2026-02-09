import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Lightweight analytics wrapper guarded by user consent.
/// Currently logs events to debug output when `innstillinger.analytics_opt_in` is true.
class Analytics {
  static bool get _enabled =>
      Hive.box('innstillinger').get('analytics_opt_in', defaultValue: false)
          as bool;

  static Future<void> logEvent(String name,
      [Map<String, dynamic>? params]) async {
    if (!_enabled) return;
    try {
      // TODO: replace with real analytics provider (Firebase, Plausible, etc.)
      debugPrint('Analytics event: $name ${params ?? {}}');
    } catch (e) {
      debugPrint('Failed to log analytics event: $e');
    }
  }
}
