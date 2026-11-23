import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/data/scan_warning_catalog.dart';
import 'package:mat_sjekk/models/scan_warning.dart';
import 'package:mat_sjekk/widgets.dart';
import 'package:mat_sjekk/widgets/scan_warning_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ScanWarning tine() {
    return resolveScanWarnings(
      brand: 'TINE Lettmelk',
      productText: 'TINE Lettmelk',
      shopCountry: 'NO',
      bovaerLevel: 'yellow',
    ).popupWarnings.single;
  }

  testWidgets('popup shows what, who and how, then sources and labelled research',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ProductInfoDialogContent(
          info: const {
            'navn': 'Lettmelk',
            'merke': 'TINE',
            'shopCountry': 'NO',
            'bovaerRisk': RiskLevel.yellow,
            'bovaerRiskText': 'Gult stempel fra kildene.',
          },
          onAddItem: (_) {},
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Hva det gjelder'), findsOneWidget);
    expect(find.text('Hvem som står bak'), findsOneWidget);
    expect(find.text('Hva du kan sjekke'), findsOneWidget);
    expect(find.text('TINE SA'), findsWidgets);
    expect(find.textContaining('ovale stempelet'), findsOneWidget);

    await tester.tap(find.byKey(const Key('see-sources-no_tine')));
    await tester.pumpAndSettle();
    expect(find.text('TINE'), findsWidgets);
    expect(find.textContaining('Sist kontrollert: 02.11.2026'), findsWidgets);
    expect(find.text('Åpne lenke'), findsWidgets);

    await tester.tap(find.text('Tilbake'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('see-research-no_tine')));
    await tester.pumpAndSettle();
    expect(
      find.text(kResearchDisclaimerNb),
      findsOneWidget,
    );
    expect(find.byKey(const Key('research-disclaimer')), findsOneWidget);

    await tester.tap(find.byKey(const Key('warning-close')));
    await tester.pumpAndSettle();
    expect(find.text('Hva det gjelder'), findsNothing);
  });

  testWidgets('English chrome is used when Norwegian is turned off',
      (tester) async {
    final warning = tine();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ScanWarningPages(
          warnings: [warning],
          norwegianOverride: false,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('What this is about'), findsOneWidget);
    expect(find.text('Who is behind it'), findsOneWidget);
    expect(find.text('What you can check'), findsOneWidget);
    expect(find.text('See sources'), findsOneWidget);
    expect(find.textContaining('oval stamp'), findsOneWidget);
  });

  testWidgets('warning without a sourced brand falls back to the neutral line',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ProductInfoDialogContent(
          info: const {
            'navn': 'Ost',
            'merke': 'Apetina',
            'bovaerRisk': RiskLevel.yellow,
            'bovaerRiskText': 'Gult stempel uten bedriftskilde.',
          },
          onAddItem: (_) {},
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Hva det gjelder'), findsNothing);
    expect(find.text(kNoDocumentedSourceNb), findsOneWidget);

    await tester.tap(find.text('Uavhengig forskning'));
    await tester.pumpAndSettle();
    expect(find.text(kResearchDisclaimerNb), findsOneWidget);
    expect(find.text('Hva det gjelder'), findsNothing);
  });

  testWidgets('insect popup stays yellow and labels research as general',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ProductInfoDialogContent(
          info: const {
            'navn': 'Proteinbar',
            'merke': 'Eksempel',
            'ingredienser': 'tørket Tenebrio molitor',
            'insectConsumerRisk': RiskLevel.red,
            'insectConsumerText': 'Ingredienslisten nevner melbillelarve.',
          },
          onAddItem: (_) {},
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Rødt: kildene dokumenterer bruk'), findsNothing);
    expect(find.text('Gult: begrenset eller ufullstendig grunnlag'), findsOneWidget);
    expect(find.text(kUnsourcedWhoNb), findsOneWidget);
    expect(find.textContaining('2021/882'), findsOneWidget);

    await tester.tap(find.byKey(const Key('see-research-topic-insekter-tenebrio')));
    await tester.pumpAndSettle();
    expect(find.text(kResearchDisclaimerNb), findsOneWidget);
  });

  testWidgets('renders popup levels for the pull request screenshots',
      (tester) async {
    const save = bool.fromEnvironment('SAVE_WARNING_SCREENSHOTS');
    if (!save) return;
    final warning = tine();
    Future<void> shoot(String name, int page) async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await tester.binding.setSurfaceSize(const Size(480, 1000));
      final key = GlobalKey();
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => RepaintBoundary(
                  key: key,
                  child: ScanWarningDialog(
                    warnings: [warning],
                    norwegianOverride: true,
                    initialPage: page,
                  ),
                ),
              );
            },
            child: Text('open-$name'),
          ),
        ),
      ));
      await tester.tap(find.text('open-$name'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      final boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('/tmp/matsjekk_warning_screenshots/$name.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
      });
    }

    await shoot('warning-level1', 0);
    await shoot('warning-level2', 1);
    await shoot('warning-level3', 2);
  });
}
