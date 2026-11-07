import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/about_version.dart';

void main() {
  test('about text uses the installed version and never hardcodes 1.8', () {
    expect(
      aboutVersionLabel(versionName: '1.1.9', buildNumber: '3501947'),
      'Versjon 1.1.9 (3501947)',
    );
    expect(
      aboutVersionLabel(versionName: '', buildNumber: ''),
      'Versjon ukjent',
    );
    expect(
      aboutVersionLabel(versionName: '1.1.9', buildNumber: '3501947'),
      isNot(contains('1.8')),
    );
    expect(
      File('lib/main.dart').readAsStringSync(),
      isNot(contains('Version 1.8')),
    );
  });

  testWidgets('purchase menu stays available when ads are already removed',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            ListTile(
              title: Text(purchaseMenuTitle(
                entitled: true,
                offerLabel: 'Fjern annonser (kr 49,-)',
              )),
            ),
            ListTile(
              title: Text(purchaseMenuTitle(
                entitled: false,
                offerLabel: 'Fjern annonser (kr 49,-)',
              )),
            ),
          ],
        ),
      ),
    ));

    expect(find.text('Annonsefri er aktiv'), findsOneWidget);
    expect(find.text('Fjern annonser (kr 49,-)'), findsOneWidget);
  });
}
