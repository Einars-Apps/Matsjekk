import 'dart:async';

import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum PremiumMessageKey {
  none,
  storeUnavailable,
  purchaseStreamError,
  productsLoadFailed,
  productIdNotFound,
  paymentConfirmed,
  purchaseFailed,
  purchaseCancelled,
}

class PremiumService {
  static const String removeAdsProductId = 'matsjekk_remove_ads_lifetime';
  static const String adsRemovedKey = 'adsRemoved';
  static const String premiumActiveKey = adsRemovedKey;
  static const String legacyPremiumActiveKey = 'premiumActive';

  final InAppPurchase _iap = InAppPurchase.instance;

  Box? _settingsBox;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool isStoreAvailable = false;
  bool isPremiumActive = false;
  bool isLoading = true;
  PremiumMessageKey lastMessageKey = PremiumMessageKey.none;
  String lastMessageExtra = '';
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

    isStoreAvailable = await _iap.isAvailable();
    if (!isStoreAvailable) {
      lastMessageKey = PremiumMessageKey.storeUnavailable;
      return;
    }

    _purchaseSubscription?.cancel();
    _purchaseSubscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        lastMessageKey = PremiumMessageKey.purchaseStreamError;
        lastMessageExtra = '$error';
      },
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    if (!isStoreAvailable) return;

    isLoading = true;
    final response = await _iap.queryProductDetails(
      {removeAdsProductId},
    );

    products = response.productDetails.toList();

    if (response.error != null) {
      lastMessageKey = PremiumMessageKey.productsLoadFailed;
    } else if (products.isEmpty) {
      lastMessageKey = PremiumMessageKey.productIdNotFound;
    } else {
      lastMessageKey = PremiumMessageKey.none;
    }

    isLoading = false;
  }

  Future<void> buy(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
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
        lastMessageKey = PremiumMessageKey.paymentConfirmed;
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        lastMessageKey = PremiumMessageKey.purchaseFailed;
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        lastMessageKey = PremiumMessageKey.purchaseCancelled;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
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
