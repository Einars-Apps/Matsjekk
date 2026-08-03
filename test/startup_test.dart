import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/startup.dart';

void main() {
  test(
      'initializeAppDependencies completes even when ads initialization throws',
      () async {
    var adsInitialized = false;

    await expectLater(
      initializeAppDependencies(
        initializeHive: null,
        initializeAds: () async {
          adsInitialized = true;
          throw Exception('ads failed');
        },
      ),
      completes,
    );

    expect(adsInitialized, isTrue);
  });
}
