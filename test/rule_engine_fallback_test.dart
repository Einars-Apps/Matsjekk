import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/rules/rule_engine.dart';

void main() {
  test('fallback to non-preferred source when preferred below threshold', () {
  const rules = [
    RuleTrigger(
      id: 'bovaer',
      description: 'bovaer',
      minConfidence: 0.7,
      preferredSources: ['Matvaretabellen'],
      enabled: true),
  ];
  final engine = RuleEngine(rules: rules);
    final product = {
      'merke': 'Tine AS',
      'sources': [
        {'source': 'OpenFoodFacts', 'confidence': 0.8},
        {'source': 'Matvaretabellen', 'confidence': 0.5},
      ],
    };
    final results = engine.evaluate(product);
    expect(results.isNotEmpty, true);
    final r = results.first;
    expect(r.ruleId, 'bovaer');
    // preferred Matvaretabellen was below threshold (0.5), fallback OpenFoodFacts used (0.8)
    expect(r.confidence >= 0.8, true);
  final prefUsed =
    (r.evidence.isNotEmpty && r.evidence.first.containsKey('preferredUsed'))
      ? r.evidence.first['preferredUsed']
      : null;
  expect(prefUsed, false);
  });
}
