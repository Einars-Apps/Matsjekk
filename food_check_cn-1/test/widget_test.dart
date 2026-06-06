import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_check_cn/main.dart';

void main() {
  testWidgets('App starts and displays Home Screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Home Screen has a title', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Shopping List Screen navigates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final shoppingListButton = find.byKey(Key('shoppingListButton'));
    await tester.tap(shoppingListButton);
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListScreen), findsOneWidget);
  });
}