import 'dart:async';
import 'dart:io' show Platform;

import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'purchases/huawei_store_billing.dart';

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
  /// The one-time "Reklamefri opplevelse" product that exists in Play Console.
  static const String androidRemoveAdsProductId = 'premium_adfree';

  /// The product id every earlier build (Android and iOS 1.1.8+65) asked for.
  /// It does not exist in Play. It is kept as the preferred iOS id and as an
  /// accepted entitlement so an earlier purchase under it still removes ads.
  static const String legacyRemoveAdsProductId = 'matsjekk_remove_ads_lifetime';

  /// AppGallery product id. The non-consumable that already exists (Active)
  /// in AppGallery Connect IAP for Matsjekk is matsjekk_remove_ads_lifetime,
  /// so the huawei flavor sells that id. premium_adfree is still accepted.
  static const String huaweiRemoveAdsProductId = legacyRemoveAdsProductId;

  /// Play product id. Kept under this name for existing callers.
  static const String removeAdsProductId = androidRemoveAdsProductId;

  /// Any of these, purchased or restored, grants the lifetime ad-free right.
  static const Set<String> adFreeEntitlementIds = {
    androidRemoveAdsProductId,
    legacyRemoveAdsProductId,
  };
  static const String adsRemovedKey = 'adsRemoved';
  static const String premiumActiveKey = adsRemovedKey;
  static const String legacyPremiumActiveKey = 'premiumActive';

  final StoreBilling _billing;
  final bool _isIOS;

  PremiumService({StoreBilling? billing, bool? isIOS})
      : _billing = billing ??
            ((isIOS ?? Platform.isIOS) ? PluginStoreBilling() : FlavorStoreBilling()),
        _isIOS = isIOS ?? Platform.isIOS;

  /// True for the AppGallery (huawei flavor) build once the store is resolved.
  bool get isHuaweiStore {
    final billing = _billing;
    return billing is HuaweiStoreBilling ||
        (billing is FlavorStoreBilling && billing.isHuawei);
  }

  String get _storeName =>
      _isIOS ? 'App Store' : (isHuaweiStore ? 'Huawei AppGallery' : 'Google Play');

  /// Ids asked from the store. Android asks only for the Play product.
  /// The App Store id is not confirmed from code or Apple, so iOS asks for
  /// both and offers whichever StoreKit returns (legacy id first).
  List<String> get queryProductIds => _isIOS
      ? const [legacyRemoveAdsProductId, androidRemoveAdsProductId]
      : (isHuaweiStore
          ? const [huaweiRemoveAdsProductId]
          : const [androidRemoveAdsProductId]);

  /// Product id(s) shown in status messages.
  String get productIdLabel => queryProductIds.join(' / ');

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
    final ids = queryProductIds;
    final response = await _billing.queryProductDetails(ids.toSet());

    final returned = response.productDetails
        .where((product) => ids.contains(product.id))
        .toList();
    // Offer one product: the first id in preference order that the store
    // returned. On iOS that is the legacy id when StoreKit has it.
    products = [
      for (final id in ids)
        ...returned.where((product) => product.id == id).take(1),
    ].take(1).toList();

    if (response.error != null) {
      lastMessage = 'Kunne ikke hente produkter: ${response.error!.message}';
    } else if (products.isEmpty) {
      lastMessage = 'Fant ikke kjøpsproduktet. Sjekk $_storeName-konfigurasjon.';
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
      if (!adFreeEntitlementIds.contains(purchaseDetails.productID)) {
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
