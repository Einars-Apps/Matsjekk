import 'dart:async';

import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'purchases/purchase_coordinator.dart';
import 'purchases/purchase_models.dart';

enum PurchaseCatalogStatus {
  loading,
  ready,
  storeUnavailable,
  queryFailed,
  productNotReturned,
}

class PremiumService {
  static const String removeAdsProductId = lifetimeRemoveAdsProductId;
  static const String adsRemovedKey = 'adsRemoved';
  static const String premiumActiveKey = adsRemovedKey;
  static const String legacyPremiumActiveKey = 'premiumActive';

  final PurchaseCoordinator? _injected;
  PurchaseCoordinator? _live;

  PremiumService({PurchaseCoordinator? coordinator}) : _injected = coordinator;

  PurchaseCoordinator get _coordinator => _live ?? _injected!;

  Box? _settingsBox;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool isStoreAvailable = false;
  bool isPremiumActive = false;
  bool isLoading = true;
  PurchaseCatalogStatus catalogStatus = PurchaseCatalogStatus.loading;
  String lastMessage = '';
  List<LifetimeOffer> offers = [];

  bool get usesHuaweiIap =>
      _coordinator.provider == StoreProviderId.huaweiAppGallery;

  Future<void> initialize(Box settingsBox) async {
    _settingsBox = settingsBox;
    final currentValue = settingsBox.get(adsRemovedKey);
    if (currentValue is bool) {
      isPremiumActive = currentValue;
    } else {
      isPremiumActive =
          settingsBox.get(legacyPremiumActiveKey, defaultValue: false);
      await settingsBox.put(adsRemovedKey, isPremiumActive);
    }
    _live ??= _injected ??
        await PurchaseCoordinator.production(
          readEntitled: () => isPremiumActive,
          writeEntitled: _setPremiumActive,
        );
    await loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading = true;
    final catalog = await _coordinator.load();
    if (catalog.isReady) {
      catalogStatus = PurchaseCatalogStatus.ready;
      isStoreAvailable = true;
      offers = [catalog.offer!];
      lastMessage = '';
    } else {
      offers = [];
      isStoreAvailable = catalog.failure?.kind != PurchaseFailureKind.storeUnavailable &&
          catalog.failure?.kind != PurchaseFailureKind.notConfigured;
      catalogStatus = switch (catalog.failure?.kind) {
        PurchaseFailureKind.storeUnavailable ||
        PurchaseFailureKind.notConfigured =>
          PurchaseCatalogStatus.storeUnavailable,
        PurchaseFailureKind.emptyCatalog ||
        PurchaseFailureKind.productIdMismatch =>
          PurchaseCatalogStatus.productNotReturned,
        _ => PurchaseCatalogStatus.queryFailed,
      };
      lastMessage = catalog.failure?.message ?? '';
    }
    if (!usesHuaweiIap && _purchaseSubscription == null) {
      final billing = InAppPurchase.instance;
      _purchaseSubscription = billing.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) {
          lastMessage = 'Kjøpsstrøm feilet: $error';
        },
      );
    }
    isLoading = false;
  }

  Future<void> buyLifetime() async {
    final attempt = await _coordinator.buy();
    if (attempt.kind == PurchaseAttemptKind.granted) {
      await _setPremiumActive(true);
      lastMessage = 'Betaling bekreftet. Annonser er nå fjernet permanent.';
      catalogStatus = PurchaseCatalogStatus.ready;
    } else if (attempt.failure != null) {
      lastMessage = attempt.failure!.message;
    }
  }

  Future<void> restorePurchases() async {
    final attempt = await _coordinator.restore();
    if (attempt.kind == RestoreKind.granted ||
        attempt.kind == RestoreKind.preserved) {
      if (attempt.kind == RestoreKind.granted) {
        await _setPremiumActive(true);
      }
      lastMessage = isPremiumActive
          ? 'Tidligere kjøp er aktivt på denne enheten.'
          : '';
    } else if (attempt.failure != null) {
      lastMessage = attempt.failure!.message;
    }
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID != removeAdsProductId) {
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        await _setPremiumActive(true);
        lastMessage = 'Betaling bekreftet. Annonser er nå fjernet permanent.';
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        lastMessage =
            purchaseDetails.error?.message ?? 'Kjøpet feilet. Prøv igjen.';
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        lastMessage = 'Kjøpet ble avbrutt.';
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _setPremiumActive(bool value) async {
    isPremiumActive = value;
    await _settingsBox?.put(adsRemovedKey, value);
    await _settingsBox?.put(legacyPremiumActiveKey, value);
  }

  Future<void> dispose() async {
    await _purchaseSubscription?.cancel();
  }
}
