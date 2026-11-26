import 'package:flutter/services.dart';

/// AdMob is used on Play and iOS. The Huawei AppGallery flavor never
/// initializes MobileAds, never loads ads, and never shows ad slots.
///
/// [appFlavor] is set by Flutter at compile time from `--flavor`.
bool adsEnabledFor({String? flavor}) => (flavor ?? appFlavor) != 'huawei';

/// Whether this build may initialize or show AdMob.
bool get adsEnabled => adsEnabledFor();
