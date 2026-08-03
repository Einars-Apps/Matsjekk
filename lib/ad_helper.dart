import 'dart:io';

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
