import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
