import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/rules/rule_engine.dart';

void main() {
  test('configureRules applies thresholds and enabled map', () {
    final thresholds = {'bovaer': 0.5, 'gmo_fish': 0.7};
    final enabled = {'bovaer': true, 'gmo_fish': false, 'insect_meal': true};
    final configured = configureRules(thresholds, enabled);
    final bovaer = configured.firstWhere((r) => r.id == 'bovaer');
    final gmo = configured.firstWhere((r) => r.id == 'gmo_fish');
    final insect = configured.firstWhere((r) => r.id == 'insect_meal');
    expect(bovaer.minConfidence, equals(0.5));
    expect(bovaer.enabled, isTrue);
    expect(gmo.minConfidence, equals(0.7));
    expect(gmo.enabled, isFalse);
    expect(insect.enabled, isTrue);
  });
}
