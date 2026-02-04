import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/widgets.dart';

void main() {
<<<<<<< HEAD
  testWidgets('ProductInfoDialogContent shows alerts and chips', (WidgetTester tester) async {
=======
  testWidgets('ProductInfoDialogContent shows alerts and chips',
      (WidgetTester tester) async {
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
    final info = {
      'navn': 'Test Produkt',
      'merke': 'Tine',
      'bildeUrl': '',
      'nutriscore': 'B',
      'eStoffer': ['E100'],
      'allergener': ['milk'],
      'næringsinnhold': {'energy_kcal': 200},
      'alerts': [
<<<<<<< HEAD
        {'ruleId': 'bovaer', 'severity': 'red', 'reason': 'Merke i rød-liste', 'confidence': 0.9, 'evidence': [{'brand': 'tine'}]}
      ]
    };

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: ProductInfoDialogContent(info: info, onAddItem: (_) {}))));
=======
        {
          'ruleId': 'bovaer',
          'severity': 'red',
          'reason': 'Merke i rød-liste',
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
>>>>>>> 1fd8547f7f4a75b9aeb940f067391e11eaa43643
    await tester.pumpAndSettle();

    // Expect Alerts header
    expect(find.text('Alerts'), findsOneWidget);
    // Expect the ActionChip with reason text
    expect(find.text('Merke i rød-liste'), findsOneWidget);
    // Tap the chip to open details dialog
    await tester.tap(find.text('Merke i rød-liste'));
    await tester.pumpAndSettle();
    // Expanded view should show confidence and evidence lines
    expect(find.textContaining('Confidence'), findsOneWidget);
    expect(find.textContaining('Evidence'), findsWidgets);
  });
}
