import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/data/factory_customer_relations.dart';
import 'package:mat_sjekk/data/risk_brands_by_country.dart';

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
}
