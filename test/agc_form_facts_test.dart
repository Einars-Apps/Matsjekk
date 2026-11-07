import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/config/links.dart';

void main() {
  test('privacy URL matches the published page constant and is not a guessed fragment', () {
    expect(kPublicPrivacyPolicyBaseUrl, 'https://matsjekk.com/privacy.html');
    final facts = File('store/appgallery/AGC-form-facts.md').readAsStringSync();
    final privacy = File('docs/privacy.html').readAsStringSync();
    expect(privacy, contains('https://matsjekk.com/privacy.html'));
    expect(privacy, contains('Dine rettigheter (GDPR)'));
    expect(privacy, isNot(contains('id="rights"')));
    expect(facts, contains(kPublicPrivacyPolicyBaseUrl));
    expect(facts, contains('versionCode 60'));
    expect(facts, contains('versionCode 61'));
    expect(facts, contains('3501945'));
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('version: 1.2.0+3501946'));
    expect(facts, contains('1.2.0+3501946'));
    expect(facts, contains('53.85%'));
    expect(facts, contains('not a rollout percentage'));
    expect(facts, contains('178/178'));
    expect(facts, contains('9.1.0'));
    expect(facts, contains('is not a verified URL'));
    expect(facts, isNot(contains('https://matsjekk.com/privacy.html#rights')));
    expect(facts, contains('Not involved'));
    expect(facts, contains('ngt-monitor.yml'));
  });
}
