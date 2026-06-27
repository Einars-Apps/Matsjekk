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

  // Banner shown inside the shopping-list overlay. Until a dedicated unit is
  // created in AdMob it falls back to the main banner unit (allowed, but a
  // separate unit gives cleaner per-placement reporting).
  // TODO: replace with a dedicated AdMob banner unit for the shopping list.
  static String get listBannerAdUnitId => bannerAdUnitId;

  // -------------------------------------------------
  // Rewarded ad (highest eCPM; user opts in voluntarily — policy-safe).
  // Using Google's official TEST unit IDs until real units are created.
  // TODO: replace with your real AdMob rewarded unit IDs before release.
  // -------------------------------------------------
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Google test rewarded
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // Google test rewarded
    }
    throw UnsupportedError('Unsupported platform');
  }

  // -------------------------------------------------
  // Native advanced ad (blends into the results list).
  // Using Google's official TEST unit IDs until real units are created.
  // TODO: replace with your real AdMob native unit IDs before release.
  // -------------------------------------------------
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110'; // Google test native
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511'; // Google test native
    }
    throw UnsupportedError('Unsupported platform');
  }
}
