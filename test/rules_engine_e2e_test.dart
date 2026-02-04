import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/rules/rule_engine.dart';

void main() {
  test('preferred source selection and threshold', () {
<<<<<<< HEAD
    final rules = [
      RuleTrigger(id: 'bovaer', description: 'bovaer', minConfidence: 0.7, preferredSources: ['Matvaretabellen'], enabled: true),
=======
    const rules = [
      RuleTrigger(
          id: 'bovaer',
          description: 'bovaer',
          minConfidence: 0.7,
          preferredSources: ['Matvaretabellen'],
          enabled: true),
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
    ];
    final engine = RuleEngine(rules: rules);
    final product = {
      'merke': 'Tine AS',
      'sources': [
        {'source': 'OpenFoodFacts', 'confidence': 0.6},
        {'source': 'Matvaretabellen', 'confidence': 0.75},
      ],
    };
    final results = engine.evaluate(product);
<<<<<<< HEAD
    expect(results.any((r) => r.ruleId == 'bovaer' && r.confidence >= 0.7), isTrue);
  });

  test('falls back to any source when preferred missing', () {
    final rules = [
      RuleTrigger(id: 'insect_meal', description: 'insect', minConfidence: 0.5, preferredSources: ['Matvaretabellen'], enabled: true),
=======
    expect(results.any((r) => r.ruleId == 'bovaer' && r.confidence >= 0.7),
        isTrue);
  });

  test('falls back to any source when preferred missing', () {
    const rules = [
      RuleTrigger(
          id: 'insect_meal',
          description: 'insect',
          minConfidence: 0.5,
          preferredSources: ['Matvaretabellen'],
          enabled: true),
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
    ];
    final engine = RuleEngine(rules: rules);
    final product = {
      'merke': 'Neutral',
      'ingredienser': 'Insektsmel, vann',
      'sources': [
        {'source': 'OpenFoodFacts', 'confidence': 0.6},
      ],
    };
    final results = engine.evaluate(product);
<<<<<<< HEAD
    expect(results.any((r) => r.ruleId == 'insect_meal' && r.confidence >= 0.6), isTrue);
=======
    expect(results.any((r) => r.ruleId == 'insect_meal' && r.confidence >= 0.6),
        isTrue);
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
  });
}
