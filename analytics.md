# Analytics (Plausible) — Enablement & Testing

This document explains how to enable Plausible analytics for `mat_sjekk` and how to test it locally.

Overview
- The app ships a consent-aware analytics wrapper in `lib/analytics.dart`.
- Analytics are only sent when the Hive boolean key `analytics_opt_in` is true.
- The analytics provider is chosen by the Hive string key `analytics_provider`.

Plausible setup keys
- `analytics_provider` — set to `plausible` to enable Plausible sending.
- `plausible_api_key` — your Plausible API key (server-side API key). Keep secret.
- `plausible_domain` — the domain you configured in Plausible (e.g. `matsjekk.com`).

How it works
- If `analytics_opt_in` is true and `analytics_provider` equals `plausible`,
  the app will POST events to `https://plausible.io/api/event` using the
  `plausible_api_key` and `plausible_domain` values.
- If anything is missing the wrapper falls back to logging events via `debugPrint`.

Security & privacy
- Do NOT commit your Plausible API key into source control.
- For production, store the Plausible API key in a secure place (CI secrets, server-side proxy, or use an authenticated backend).

Local testing (recommended)
1. For quick local testing, use the debug helper included in the repo: `lib/debug_analytics.dart`.
   - Call `DebugAnalytics.configurePlausible(apiKey, domain)` from a debug-only location (for example, inside `main()` guarded by `kDebugMode`).
   - This writes the required Hive keys so you can test the full flow without exposing keys in source control.
2. Run the app in debug mode and enable analytics via the app's `Personvern` dialog (toggle `analytics_opt_in`).
3. Trigger the flows you want instrumented (scanning a product, adding to list). Watch logs — successful Plausible calls will be printed to debug output.

Example snippet (debug-only)
```dart
import 'package:flutter/foundation.dart';
import 'debug_analytics.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    DebugAnalytics.configurePlausible('YOUR_TEST_API_KEY', 'your-domain.com');
  }
  runApp(const MatvareSjekkApp());
}
```

Questions or next steps
- I can add a small UI to the `Personvern` dialog for configuring the provider/domain for debug builds only.
- Alternatively we can wire a server-side proxy so the app never carries an API key.
