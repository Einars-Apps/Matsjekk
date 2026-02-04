import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/rules/rule_engine.dart';

void main() {
  test('bovaer rule flags red brand', () {
    final engine = RuleEngine(rules: defaultRules());
<<<<<<< HEAD
    final product = {'merke': 'Tine AS', 'etiketter': '', 'kategorier': '', 'ingredienser': '', 'sourceConfidence': 0.8};
    final results = engine.evaluate(product);
    expect(results.any((r) => r.ruleId == 'bovaer' && r.severity == 'red'), isTrue);
=======
    final product = {
      'merke': 'Tine AS',
      'etiketter': '',
      'kategorier': '',
      'ingredienser': '',
      'sourceConfidence': 0.8
    };
    final results = engine.evaluate(product);
    expect(results.any((r) => r.ruleId == 'bovaer' && r.severity == 'red'),
        isTrue);
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
  });

  test('insect meal detection triggers on ingredient mention', () {
    final engine = RuleEngine(rules: defaultRules());
<<<<<<< HEAD
    final product = {'merke': 'Neutral', 'etiketter': '', 'kategorier': '', 'ingredienser': 'Insektsmel, vann', 'sourceConfidence': 0.9};
=======
    final product = {
      'merke': 'Neutral',
      'etiketter': '',
      'kategorier': '',
      'ingredienser': 'Insektsmel, vann',
      'sourceConfidence': 0.9
    };
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
    final results = engine.evaluate(product);
    expect(results.any((r) => r.ruleId == 'insect_meal'), isTrue);
  });
}
