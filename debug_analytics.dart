import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Debug helper to configure analytics provider keys in Hive for local testing.
/// This should only be used in development. Do NOT call this in production.
class DebugAnalytics {
  /// Write Plausible config to Hive (debug-only).
  static Future<void> configurePlausible(String apiKey, String domain) async {
    if (!kDebugMode) return;
    final box = Hive.box('innstillinger');
    await box.put('analytics_provider', 'plausible');
    await box.put('plausible_api_key', apiKey);
    await box.put('plausible_domain', domain);
    // Optionally enable analytics opt-in for quicker testing
    await box.put('analytics_opt_in', true);
    debugPrint('DebugAnalytics: Plausible configured (debug only)');
  }
}
