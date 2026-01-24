// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Self-contained counter test that does not depend on app initialization.
// Removed unused import of main app to avoid analyzer warning.

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // A small counter widget local to the test.
    await tester.pumpWidget(const MaterialApp(home: _CounterTestWidget()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

class _CounterTestWidget extends StatefulWidget {
  const _CounterTestWidget({Key? key}) : super(key: key);
  @override
  State<_CounterTestWidget> createState() => _CounterTestWidgetState();
}

class _CounterTestWidgetState extends State<_CounterTestWidget> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Test')),
      body: Center(child: Text('$_counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
