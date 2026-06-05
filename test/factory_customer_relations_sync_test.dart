import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/data/factory_customer_relations.dart';

String _key(String country, String factory, String customer, String source) {
  return '${country.toUpperCase()}|${factory.trim().toLowerCase()}|${customer.trim().toLowerCase()}|${source.trim()}';
}

void main() {
  test('factory_customer_relations.dart is synced with docs JSON', () {
    final jsonFile = File('docs/data/factory_customer_relations.json');
    expect(
      jsonFile.existsSync(),
      isTrue,
      reason: 'Missing docs/data/factory_customer_relations.json',
    );

    final decoded = json.decode(jsonFile.readAsStringSync()) as Map<String, dynamic>;
    final countries = decoded['countries'] as Map<String, dynamic>? ?? const {};

    final jsonKeys = <String>{};
    countries.forEach((country, entries) {
      final list = entries as List<dynamic>;
      for (final item in list) {
        final relation = item as Map<String, dynamic>;
        jsonKeys.add(
          _key(
            country,
            (relation['factory'] ?? '').toString(),
            (relation['customer'] ?? '').toString(),
            (relation['source'] ?? '').toString(),
          ),
        );
      }
    });

    final dartKeys = <String>{};
    factoryCustomerRelationsByCountry.forEach((country, relations) {
      for (final relation in relations) {
        dartKeys.add(_key(country, relation.factory, relation.customer, relation.source));
      }
    });

    final onlyInDart = dartKeys.difference(jsonKeys).toList()..sort();
    final onlyInJson = jsonKeys.difference(dartKeys).toList()..sort();

    expect(
      onlyInDart,
      isEmpty,
      reason: 'Relations only in Dart: ${onlyInDart.join(', ')}',
    );
    expect(
      onlyInJson,
      isEmpty,
      reason: 'Relations only in JSON: ${onlyInJson.join(', ')}',
    );
  });
}
