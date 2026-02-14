import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Lightweight analytics wrapper guarded by user consent.
/// Currently logs events to debug output when `innstillinger.analytics_opt_in` is true.
class Analytics {
  static bool get _enabled =>
      // If Hive hasn't been initialized or the box isn't open, treat analytics
      // as disabled. Accessing `Hive.box` when the box is not open can throw
      // in tests or early startup, so guard the call.
      (() {
        try {
          if (!Hive.isBoxOpen('innstillinger')) return false;
          final val = Hive.box('innstillinger')
              .get('analytics_opt_in', defaultValue: false);
          return val is bool ? val : false;
        } catch (_) {
          return false;
        }
      })();

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
