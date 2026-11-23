import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mat_sjekk/about_version.dart';
import 'package:mat_sjekk/premium_screen.dart';
import 'package:mat_sjekk/premium_service.dart';

import 'helpers.dart';

void main() {
  setUp(() async {
    await setUpHiveForTest();
  });

  tearDown(() async {
    await tearDownHiveForTest();
  });

  test('reinstall with no local flag restores the lifetime purchase', () async {
    final billing = _FakeBilling(
      ownedOnRestore: [_purchase(PurchaseStatus.restored)],
    );
    final box = Hive.box('innstillinger');
    final service = PremiumService(billing: billing);

    await service.initialize(box);

    expect(billing.restoreCalls, 1);
    expect(service.isPremiumActive, isTrue);
    expect(box.get(PremiumService.adsRemovedKey), isTrue);
    expect(box.get(PremiumService.legacyPremiumActiveKey), isTrue);
    await service.dispose();
  });

  test('restored grant stays after a later empty list and an error event', () async {
    final billing = _FakeBilling(
      ownedOnRestore: [
        _purchase(PurchaseStatus.restored),
      ],
      afterOwned: [
        const [],
        [_purchase(PurchaseStatus.error)],
      ],
    );
    final box = Hive.box('innstillinger');
    final service = PremiumService(billing: billing);

    await service.initialize(box);

    expect(service.isPremiumActive, isTrue);
    expect(box.get(PremiumService.adsRemovedKey), isTrue);
    await service.dispose();
  });

  test('empty restore and a different product do not grant a fresh install',
      () async {
    final billing = _FakeBilling(
      ownedOnRestore: [_purchase(PurchaseStatus.restored, productId: 'other')],
    );
    final box = Hive.box('innstillinger');
    final service = PremiumService(billing: billing);

    await service.initialize(box);
    await _settle();

    expect(billing.restoreCalls, 1);
    expect(service.isPremiumActive, isFalse);
    expect(box.get(PremiumService.adsRemovedKey), isNot(true));
    await service.dispose();
  });

  test('existing paid flag survives empty catalog, empty restore, and errors',
      () async {
    final billing = _FakeBilling(
      catalog: ProductDetailsResponse(
        productDetails: const [],
        notFoundIDs: [PremiumService.removeAdsProductId],
        error: IAPError(source: 'google_play', code: 'itemUnavailable', message: 'missing'),
      ),
      ownedOnRestore: const [],
      restoreError: StateError('billing disconnected'),
    );
    final box = Hive.box('innstillinger');
    await box.put(PremiumService.adsRemovedKey, true);
    final service = PremiumService(billing: billing);

    await service.initialize(box);
    billing.emit([_purchase(PurchaseStatus.error)]);
    billing.emit(const []);
    billing.streamController.addError(StateError('stream failed'));
    await service.restorePurchases();
    await _settle();

    expect(billing.restoreCalls, 1);
    expect(service.isPremiumActive, isTrue);
    expect(box.get(PremiumService.adsRemovedKey), isTrue);
    expect(service.products, isEmpty);
    await service.dispose();
  });

  test('store unavailable does not query or clear an existing paid flag',
      () async {
    final billing = _FakeBilling(available: false);
    final box = Hive.box('innstillinger');
    await box.put(PremiumService.adsRemovedKey, true);
    final service = PremiumService(billing: billing);

    await service.initialize(box);

    expect(billing.queryCalls, 0);
    expect(billing.restoreCalls, 0);
    expect(service.isPremiumActive, isTrue);
    expect(box.get(PremiumService.adsRemovedKey), isTrue);
    await service.dispose();
  });

  test('an already ad-free install does not auto-query owned purchases',
      () async {
    final billing = _FakeBilling(
      ownedOnRestore: [_purchase(PurchaseStatus.restored)],
    );
    final box = Hive.box('innstillinger');
    await box.put(PremiumService.adsRemovedKey, true);
    final service = PremiumService(billing: billing);

    await service.initialize(box);
    await _settle();

    expect(billing.restoreCalls, 0);
    expect(box.get(PremiumService.adsRemovedKey), isTrue);
    await service.dispose();
  });

  test('owned install keeps the product but does not offer or re-query a purchase',
      () async {
    final billing = _FakeBilling();
    final box = Hive.box('innstillinger');
    await box.put(PremiumService.adsRemovedKey, true);
    final service = PremiumService(billing: billing);

    await service.initialize(box);

    expect(service.isPremiumActive, isTrue);
    expect(service.products, isNotEmpty);
    expect(billing.restoreCalls, 0);
    expect(
      offersNewPurchase(
        loading: service.isLoading,
        storeAvailable: service.isStoreAvailable,
        hasProduct: service.products.isNotEmpty,
        entitled: service.isPremiumActive,
      ),
      isFalse,
    );
    expect(box.get(PremiumService.adsRemovedKey), isTrue);
    await service.dispose();
  });

  testWidgets('owned screen shows status and restore without a new purchase button',
      (tester) async {
    final box = Hive.box('innstillinger');
    // Hive file IO does not complete inside the widget tester's fake clock.
    // Do that write in real time before any animated widget exists. A later
    // runAsync while CircularProgressIndicator is ticking does not go idle.
    await tester.runAsync(() async {
      await box.put(PremiumService.adsRemovedKey, true);
    });
    final billing = _FakeBilling();
    await tester.pumpWidget(MaterialApp(
      home: PremiumScreen(
        innstillingerBox: box,
        onPremiumChanged: (_) {},
        service: PremiumService(billing: billing),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('Annonsefri er aktiv'), findsWidgets);
    expect(find.textContaining('Kjøp tilbys ikke på nytt'), findsOneWidget);
    expect(find.text('Gjenopprett kjøp'), findsOneWidget);
    expect(find.text('Kjøp permanent'), findsNothing);
    expect(billing.restoreCalls, 0);
    expect(box.get(PremiumService.adsRemovedKey), isTrue);
  });

  testWidgets('unowned screen still offers the one-time purchase and restore',
      (tester) async {
    final box = Hive.box('innstillinger');
    await tester.runAsync(() async {
      await box.put(PremiumService.adsRemovedKey, false);
    });
    final billing = _FakeBilling(ownedOnRestore: const []);
    await tester.pumpWidget(MaterialApp(
      home: PremiumScreen(
        innstillingerBox: box,
        onPremiumChanged: (_) {},
        service: PremiumService(billing: billing),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Kjøp permanent'), findsOneWidget);
    expect(find.textContaining('ekte Google Play-fakturering'), findsOneWidget);
    expect(find.text('Gjenopprett kjøp'), findsOneWidget);
    expect(box.get(PremiumService.adsRemovedKey), isFalse);
  });

  testWidgets('missing Play product explains why purchase cannot start',
      (tester) async {
    final box = Hive.box('innstillinger');
    await tester.runAsync(() async {
      await box.put(PremiumService.adsRemovedKey, false);
    });
    final billing = _FakeBilling(
      catalog: ProductDetailsResponse(
        productDetails: const [],
        notFoundIDs: [PremiumService.removeAdsProductId],
      ),
      ownedOnRestore: const [],
    );
    await tester.pumpWidget(MaterialApp(
      home: PremiumScreen(
        innstillingerBox: box,
        onPremiumChanged: (_) {},
        service: PremiumService(billing: billing),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('Play returnerte ikke matsjekk_remove_ads_lifetime'), findsWidgets);
    expect(find.textContaining('lisens-tester'), findsOneWidget);
    expect(find.text('Kjøp permanent'), findsNothing);
    expect(find.text('Gjenopprett kjøp'), findsOneWidget);
    expect(box.get(PremiumService.adsRemovedKey), isFalse);
  });

  testWidgets('restore control is shown without an iOS-only gate', (tester) async {
    final billing = _FakeBilling(available: false);
    await tester.pumpWidget(MaterialApp(
      home: PremiumScreen(
        innstillingerBox: Hive.box('innstillinger'),
        onPremiumChanged: (_) {},
        service: PremiumService(billing: billing),
      ),
    ));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();

    expect(find.text('Gjenopprett kjøp'), findsOneWidget);
    expect(
      File('lib/premium_screen.dart').readAsStringSync(),
      isNot(contains('Platform.isIOS')),
    );
  });
}

Future<void> _settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
}

PurchaseDetails _purchase(PurchaseStatus status, {String? productId}) {
  return PurchaseDetails(
    productID: productId ?? PremiumService.removeAdsProductId,
    verificationData: PurchaseVerificationData(
      localVerificationData: 'local',
      serverVerificationData: 'server',
      source: 'google_play',
    ),
    transactionDate: '0',
    status: status,
  )..error = status == PurchaseStatus.error
      ? IAPError(source: 'google_play', code: 'error', message: 'failed')
      : null;
}

class _FakeBilling implements StoreBilling {
  _FakeBilling({
    this.available = true,
    this.catalog,
    this.ownedOnRestore = const [],
    this.afterOwned = const [],
    this.restoreError,
  });

  final bool available;
  final ProductDetailsResponse? catalog;
  final List<PurchaseDetails> ownedOnRestore;
  final List<List<PurchaseDetails>> afterOwned;
  final Object? restoreError;
  final StreamController<List<PurchaseDetails>> streamController =
      StreamController<List<PurchaseDetails>>.broadcast();

  int restoreCalls = 0;
  int queryCalls = 0;

  void emit(List<PurchaseDetails> purchases) {
    streamController.add(purchases);
  }

  @override
  Future<bool> isAvailable() async => available;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => streamController.stream;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) async {
    queryCalls += 1;
    return catalog ??
        ProductDetailsResponse(
          productDetails: [
            ProductDetails(
              id: PremiumService.removeAdsProductId,
              title: 'Remove ads',
              description: 'Lifetime',
              price: 'kr 49',
              rawPrice: 49,
              currencyCode: 'NOK',
            ),
          ],
          notFoundIDs: const [],
        );
  }

  @override
  Future<void> restorePurchases() async {
    restoreCalls += 1;
    final error = restoreError;
    if (error != null) throw error;
    streamController.add(ownedOnRestore);
    for (final extra in afterOwned) {
      streamController.add(extra);
    }
  }

  @override
  Future<void> buyNonConsumable({required PurchaseParam purchaseParam}) async {}

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}
}
