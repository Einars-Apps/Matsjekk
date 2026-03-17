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
      // TODO: replace with real Android Banner Ad Unit ID
      return 'ca-app-pub-3940256099942544/6300978111'; // test
    } else if (Platform.isIOS) {
      // TODO: replace with real iOS Banner Ad Unit ID
      return 'ca-app-pub-3940256099942544/2934735716'; // test
    }
    throw UnsupportedError('Unsupported platform');
  }
}
