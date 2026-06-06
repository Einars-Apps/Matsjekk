import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_check_cn/main.dart';

void main() {
  testWidgets('App should display the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Home screen should navigate to scan screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final Finder scanButton = find.byKey(Key('scanButton'));
    await tester.tap(scanButton);
    await tester.pumpAndSettle();

    expect(find.text('Scan'), findsOneWidget);
  });

  testWidgets('Home screen should navigate to search screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final Finder searchButton = find.byKey(Key('searchButton'));
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('Home screen should navigate to shopping list screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final Finder shoppingListButton = find.byKey(Key('shoppingListButton'));
    await tester.tap(shoppingListButton);
    await tester.pumpAndSettle();

    expect(find.text('Shopping List'), findsOneWidget);
  });
}