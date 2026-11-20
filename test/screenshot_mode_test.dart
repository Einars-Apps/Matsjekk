import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/ad_helper.dart';

void main() {
  test('SCREENSHOT_MODE is off unless explicitly defined', () {
    // Release/normal builds must keep ads; only
    // --dart-define=SCREENSHOT_MODE=true turns this on.
    expect(kScreenshotMode, isFalse);
  });
}
