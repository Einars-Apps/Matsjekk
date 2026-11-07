import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/widgets.dart';

void main() {
  testWidgets('ProductInfoDialogContent shows alerts and chips',
      (WidgetTester tester) async {
    final info = {
      'navn': 'Test Produkt',
      'merke': 'Tine',
      'bildeUrl': '',
      'nutriscore': 'B',
      'eStoffer': ['E100'],
      'allergener': ['milk'],
      'næringsinnhold': {'energy_kcal': 200},
      'alerts': [
        {
          'ruleId': 'bovaer',
          'severity': 'yellow',
          'reason': 'Merke i gul-liste',
          'confidence': 0.9,
          'evidence': [
            {'brand': 'tine'}
          ]
        }
      ]
    };

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ProductInfoDialogContent(info: info, onAddItem: (_) {}))));
    await tester.pumpAndSettle();

    // Expect Alerts header
    expect(find.text('Alerts'), findsOneWidget);
    // Expect the ActionChip with reason text
    final chip = find.ancestor(
      of: find.text('Merke '),
      matching: find.byType(ActionChip),
    );
    expect(chip, findsOneWidget);
    await tester.tap(chip);
    await tester.pumpAndSettle();
    // Expanded view should show confidence and evidence lines
    expect(find.textContaining('Confidence'), findsOneWidget);
    expect(find.textContaining('Evidence'), findsWidgets);
  });
}
