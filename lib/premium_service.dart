import 'dart:async';
import 'dart:io' show Platform;

import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Play/App Store calls used by [PremiumService]. Production uses
/// [PluginStoreBilling]. Tests supply a fake so no store is contacted.
abstract class StoreBilling {
  Future<bool> isAvailable();
  Stream<List<PurchaseDetails>> get purchaseStream;
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers);
  Future<void> buyNonConsumable({required PurchaseParam purchaseParam});
  Future<void> restorePurchases();
  Future<void> completePurchase(PurchaseDetails purchase);
}

class PluginStoreBilling implements StoreBilling {
  PluginStoreBilling([InAppPurchase? iap]) : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) {
    return _iap.queryProductDetails(identifiers);
  }

  @override
  Future<void> buyNonConsumable({required PurchaseParam purchaseParam}) {
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    return _iap.completePurchase(purchase);
  }
}

class PremiumService {
  static const String removeAdsProductId = 'matsjekk_remove_ads_lifetime';
  static const String adsRemovedKey = 'adsRemoved';
  static const String premiumActiveKey = adsRemovedKey;
  static const String legacyPremiumActiveKey = 'premiumActive';

  final StoreBilling _billing;

  PremiumService({StoreBilling? billing}) : _billing = billing ?? PluginStoreBilling();

  Box? _settingsBox;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Future<void> _updateChain = Future<void>.value();

  bool isStoreAvailable = false;
  bool isPremiumActive = false;
  bool isLoading = true;
  String lastMessage = '';
  List<ProductDetails> products = [];

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

    isStoreAvailable = await _billing.isAvailable();
    if (!isStoreAvailable) {
      lastMessage = 'Butikk utilgjengelig akkurat nå. Prøv igjen senere.';
      isLoading = false;
      return;
    }

    _purchaseSubscription?.cancel();
    _updateChain = Future<void>.value();
    _purchaseSubscription = _billing.purchaseStream.listen(
      (purchases) {
        _updateChain = _updateChain.then((_) => _handlePurchaseUpdates(purchases));
      },
      onError: (error) {
        lastMessage = 'Kjøpsstrøm feilet: $error';
      },
    );

    await loadProducts();
    await _updateChain;
    // Ask Play for owned non-consumables once per subscription, and only when
    // this install does not already have the local lifetime right. Wait until
    // the stream handlers finish so a grant is visible before initialize
    // returns. A later empty or failed result must not clear that right.
    if (!isPremiumActive) {
      await restorePurchases();
      await _updateChain;
    }
  }

  Future<void> loadProducts() async {
    if (!isStoreAvailable) return;

    isLoading = true;
    final response = await _billing.queryProductDetails(
      {removeAdsProductId},
    );

    products = response.productDetails.toList();

    if (response.error != null) {
      lastMessage = 'Kunne ikke hente produkter: ${response.error!.message}';
    } else if (products.isEmpty) {
      lastMessage = Platform.isIOS
          ? 'Fant ikke kjøpsproduktet. Sjekk App Store-konfigurasjon.'
          : 'Fant ikke kjøpsproduktet. Sjekk Google Play-konfigurasjon.';
    } else {
      lastMessage = '';
    }

    isLoading = false;
  }

  Future<void> buy(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _billing.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    try {
      await _billing.restorePurchases();
    } catch (error) {
      lastMessage = 'Kjøpsstrøm feilet: $error';
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
        await _billing.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _setPremiumActive(bool value) async {
    // Purchase updates only grant. They never clear a stored lifetime right.
    if (!value) return;
    isPremiumActive = value;
    await _settingsBox?.put(adsRemovedKey, value);
    await _settingsBox?.put(legacyPremiumActiveKey, value);
  }

  Future<void> dispose() async {
    await _purchaseSubscription?.cancel();
  }
}
