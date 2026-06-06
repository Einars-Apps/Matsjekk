import 'package:flutter_test/flutter_test.dart';
import 'package:food_check_cn/l10n/l10n.dart';

void main() {
  group('Localization Tests', () {
    late L10n l10n;

    setUp(() {
      l10n = L10n();
    });

    test('should return Chinese strings', () {
      expect(l10n.getString('app_title', locale: 'zh'), '应用标题');
      expect(l10n.getString('welcome_message', locale: 'zh'), '欢迎使用我们的应用');
    });

    test('should return English strings', () {
      expect(l10n.getString('app_title', locale: 'en'), 'App Title');
      expect(l10n.getString('welcome_message', locale: 'en'), 'Welcome to our app');
    });

    test('should return default string for unsupported locale', () {
      expect(l10n.getString('app_title', locale: 'fr'), 'App Title');
    });
  });
}