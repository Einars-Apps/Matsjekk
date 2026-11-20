import 'dart:io';

/// Store-screenshot builds only:
///   flutter build apk --dart-define=SCREENSHOT_MODE=true
/// hides every ad banner and the "remove ads" upsell bar so the Play/App
/// Store screenshots contain no (test) ads. It defaults to false, so normal
/// release builds (which never pass this define) keep ads exactly as before.
const bool kScreenshotMode = bool.fromEnvironment('SCREENSHOT_MODE');

class AdHelper {
  // -------------------------------------------------
  // Replace test IDs with your real AdMob unit IDs
  // before releasing to production.
  // Android App ID  → set in AndroidManifest.xml
  // iOS App ID      → set in Info.plist (GADApplicationIdentifier)
  // -------------------------------------------------

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2847767410024665/3715887562';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2847767410024665/9898152537';
    }
    throw UnsupportedError('Unsupported platform');
  }
}
