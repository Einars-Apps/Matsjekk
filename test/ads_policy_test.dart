import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/ads_policy.dart';

void main() {
  test('AdMob stays on for Play, iOS and unflavored builds', () {
    expect(adsEnabledFor(flavor: 'play'), isTrue);
    expect(adsEnabledFor(flavor: null), isTrue);
    expect(adsEnabledFor(flavor: ''), isTrue);
  });

  test('the Huawei flavor never enables AdMob', () {
    expect(adsEnabledFor(flavor: 'huawei'), isFalse);
  });

  test('this test run is not a Huawei flavor, so ads stay enabled', () {
    // flutter test does not pass --flavor, so the Play path is what we verify.
    expect(adsEnabled, isTrue);
  });
}
