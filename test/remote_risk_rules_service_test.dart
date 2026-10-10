import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mat_sjekk/services/remote_risk_rules_service.dart';

void main() {
  late Directory directory;
  late Box settings;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('risk_rules_test_');
    Hive.init(directory.path);
    settings = await Hive.openBox('risk_rules_test');
  });

  tearDown(() async {
    await settings.close();
    await directory.delete(recursive: true);
  });

  test('reads all remotely configurable categories and explicit empty lists',
      () async {
    await settings.put(
      'remote_risk_rules_cache_v2',
      jsonEncode({
        'countries': {
          'no': {
            'bovaer_red': [],
            'bovaer_yellow': ['test'],
            'gmo_fish_red': ['fish'],
            'organic_keywords': ['organic'],
            'gmo_supply_chain_yellow': ['feed'],
            'gmo_eu_watch': ['gmo'],
            'insect_supply_chain_yellow': ['insect'],
            'insect_eu_watch': ['mealworm'],
            'factory_customer_yellow': ['customer'],
          },
        },
      }),
    );
    final rules = RemoteRiskRulesService(settings).readCachedRules()['NO']!;
    expect(rules['bovaer_red'], isEmpty);
    expect(rules['gmo_supply_chain_yellow'], ['feed']);
    expect(rules['gmo_eu_watch'], ['gmo']);
    expect(rules['insect_supply_chain_yellow'], ['insect']);
    expect(rules['insect_eu_watch'], ['mealworm']);
    expect(rules['factory_customer_yellow'], ['customer']);
    expect(rules.length, 9);
  });
}
