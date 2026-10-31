import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/data/factory_customer_relations.dart';
import 'package:mat_sjekk/data/risk_brands_by_country.dart';

const _tineFamily = [
  'tine',
  'synnøve',
  'synnøve finden',
  'fjordland',
  'ostecompagniet',
  'q-meieriene',
  'q meieriene',
  'kavli',
  'jarlsberg',
  'norvegia',
  'biola',
  'litago',
  'snøfrisk',
  'gudbrandsdalsost',
  'ski queen',
];

void main() {
  test('factory customer signals exist for NO', () {
    final signals = getFactoryCustomerYellowSignals('NO');
    expect(signals.contains('tine'), isTrue);
    expect(signals.contains('fjordland'), isTrue);
  });

  test('factory customer signals fallback to NO for unknown country', () {
    final unknownSignals = getFactoryCustomerYellowSignals('ZZ');
    final noSignals = getFactoryCustomerYellowSignals('NO');
    expect(unknownSignals, equals(noSignals));
  });

  test('country rules expose merged factory customer key', () {
    final noRules = getRiskBrandsForCountry('NO');
    final factorySignals = noRules['factory_customer_yellow'] ?? const [];
    expect(factorySignals, isNotEmpty);
    expect(factorySignals.any((s) => s.toLowerCase() == 'tine'), isTrue);
  });

  test('TINE and TINE brands are yellow for Bovaer, not red', () {
    expect(
        tineBovaerYellowReasonNb, contains('ikke lenger leverer Bovaer-melk'));
    expect(tineBovaerYellowReasonNb, contains('eldre produkter'));

    for (final country in riskBrandsByCountry.keys) {
      final reds = (getRiskBrandsForCountry(country)['bovaer_red'] ?? const [])
          .map((brand) => brand.toLowerCase())
          .toSet();
      for (final brand in _tineFamily) {
        expect(
          reds.contains(brand),
          isFalse,
          reason: '$brand is red in $country',
        );
      }
    }

    final noYellow =
        (getRiskBrandsForCountry('NO')['bovaer_yellow'] ?? const [])
            .map((brand) => brand.toLowerCase())
            .toSet();
    for (final brand in _tineFamily) {
      expect(noYellow.contains(brand), isTrue,
          reason: '$brand missing from NO yellow');
    }

    final riskJson = json.decode(File('docs/data/risk.json').readAsStringSync())
        as Map<String, dynamic>;
    expect(riskJson['updated_at'], '2026-10-31');
    final riskNo = riskJson['NO'] as Map<String, dynamic>;
    final riskRed = (riskNo['bovaer_red'] as List)
        .map((brand) => brand.toString().toLowerCase())
        .toSet();
    final riskYellow = (riskNo['bovaer_yellow'] as List)
        .map((brand) => brand.toString().toLowerCase())
        .toSet();
    for (final brand in _tineFamily) {
      expect(riskRed.contains(brand), isFalse,
          reason: '$brand is red in risk.json');
      expect(riskYellow.contains(brand), isTrue,
          reason: '$brand missing from risk.json yellow');
    }
    expect(riskRed.contains('arla'), isTrue);
    final notes = riskNo['bovaer_notes'] as List;
    expect(notes.single['text'], tineBovaerYellowReasonNb);

    final rulesJson =
        json.decode(File('docs/supplier_rules_v2.json').readAsStringSync())
            as Map<String, dynamic>;
    expect(rulesJson['updated_at'], '2026-10-19');
    expect(rulesJson['tine_bovaer_note_nb'], tineBovaerYellowReasonNb);
    expect(rulesJson['version'], 2);
    final countries = rulesJson['countries'] as Map<String, dynamic>;
    for (final entry in countries.entries) {
      final reds = ((entry.value as Map)['bovaer_red'] as List)
          .map((brand) => brand.toString().toLowerCase())
          .toSet();
      for (final brand in _tineFamily) {
        expect(
          reds.contains(brand),
          isFalse,
          reason: '$brand is red in supplier rules ${entry.key}',
        );
      }
    }
    final rulesNo = countries['NO'] as Map<String, dynamic>;
    final rulesYellow = (rulesNo['bovaer_yellow'] as List)
        .map((brand) => brand.toString().toLowerCase())
        .toSet();
    for (final brand in _tineFamily) {
      expect(rulesYellow.contains(brand), isTrue);
    }
    expect(
      (rulesNo['bovaer_red'] as List)
          .map((brand) => brand.toString())
          .contains('arla'),
      isTrue,
    );
  });
}
