import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('alerts_feedback persistence', () async {
    final box = await Hive.openBox('alerts_feedback');
    final sample = [
      {
        'timestamp': DateTime.now().toIso8601String(),
        'product_name': 'Test Produkt',
        'gtin': '000123',
        'ruleId': 'bovaer',
        'severity': 'red',
        'note': 'Feil varsel',
        'evidence': []
      }
    ];

    await box.put('feedback_list', sample);
    final read = box.get('feedback_list');
    expect(read, isNotNull);
    expect((read as List).first['product_name'], 'Test Produkt');
    await box.close();
  });

  test('rule thresholds and enabled persistence', () async {
    final box = await Hive.openBox('innstillinger');
    await box.put('rule_thresholds', {'bovaer': 0.8});
    await box.put('rule_enabled', {'bovaer': true, 'insect_meal': false});

    final thresholds = box.get('rule_thresholds');
    final enabled = box.get('rule_enabled');
    expect(thresholds['bovaer'], 0.8);
    expect(enabled['insect_meal'], false);
    await box.close();
  });

  test('products_index persistence', () async {
    final box = await Hive.openBox('matvaretabellen_cache');
    final index = {
      'byGtin': {
        '000123': {
          'product': {'name': 'X'},
          'sources': [
            {'source': 'Matvaretabellen', 'confidence': 0.9}
          ]
        }
      }
    };
    await box.put('products_index', index);
    final read = box.get('products_index');
    expect(read['byGtin']['000123']['product']['name'], 'X');
    await box.close();
  });
}
