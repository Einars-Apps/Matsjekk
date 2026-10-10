import 'dart:convert';
import 'dart:io';

import 'package:mat_sjekk/data/risk_brands_by_country.dart';

void main() {
  final countries = <String, Map<String, List<String>>>{
    for (final country in riskBrandsByCountry.keys)
      country: getRiskBrandsForCountry(country),
  };
  final payload = {
    'version': 2,
    'origin': 'Existing app rules; export is not a new factual verification.',
    'countries': countries,
  };
  File('docs/supplier_rules_v2.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(payload)}\n',
  );
}
