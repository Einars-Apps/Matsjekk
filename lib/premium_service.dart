import 'dart:async';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'huawei_iap_service.dart';

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

  /// Cached result from [checkPurchasesAvailable].
  static bool? _purchasesAvailableCache;

  /// Whether the current device uses Huawei HMS instead of Google GMS.
  static bool _isHuaweiStore = false;
  static bool get isHuaweiStore => _isHuaweiStore;

  /// Detect if this is a Huawei device with HMS IAP.
  static Future<bool> _detectHuaweiStore() async {
    if (!Platform.isAndroid) return false;
    try {
      return await HuaweiIapService.isAvailable();
    } catch (_) {
      return false;
    }
  }

  /// Quick check whether the store is available AND the product can be loaded.
  /// Result is cached so subsequent calls are instant.
  static Future<bool> checkPurchasesAvailable() async {
    if (_purchasesAvailableCache != null) return _purchasesAvailableCache!;
    try {
      // Try Google Play first
      final iap = InAppPurchase.instance;
      if (await iap.isAvailable()) {
        final response = await iap.queryProductDetails({removeAdsProductId});
        if (response.error == null && response.productDetails.isNotEmpty) {
          _isHuaweiStore = false;
          _purchasesAvailableCache = true;
          return true;
        }
        // Google Play is present (so this is not a Huawei-only device). Do NOT
        // probe Huawei IAP here, because IapClient.isEnvReady() triggers the
        // "HMS Core not installed" dialog on every launch on non-Huawei devices.
        _purchasesAvailableCache = false;
        return false;
      }
      // Google Play unavailable — fall back to Huawei IAP
      if (Platform.isAndroid) {
        final huaweiAvailable = await _detectHuaweiStore();
        if (huaweiAvailable) {
          final product =
              await HuaweiIapService.queryProduct(removeAdsProductId);
          if (product != null) {
            _isHuaweiStore = true;
            _purchasesAvailableCache = true;
            return true;
          }
        }
      }
      _purchasesAvailableCache = false;
    } catch (_) {
      _purchasesAvailableCache = false;
    }
    return _purchasesAvailableCache!;
  }

  /// Whether purchases are known to be available (after [checkPurchasesAvailable]).
  static bool get purchasesAvailable => _purchasesAvailableCache ?? true;

  final InAppPurchase _iap = InAppPurchase.instance;

  Box? _settingsBox;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool isStoreAvailable = false;
  bool isPremiumActive = false;
  bool isLoading = true;
  PremiumMessageKey lastMessageKey = PremiumMessageKey.none;
  String lastMessageExtra = '';
  List<ProductDetails> products = [];
  HuaweiProduct? huaweiProduct;

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

    // Try Google Play first
    isStoreAvailable = await _iap.isAvailable();
    if (isStoreAvailable) {
      _isHuaweiStore = false;
      _purchaseSubscription?.cancel();
      _purchaseSubscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) {
          lastMessageKey = PremiumMessageKey.purchaseStreamError;
          lastMessageExtra = '$error';
        },
      );
      await loadProducts();
      return;
    }

    // Fall back to Huawei IAP on Android
    if (Platform.isAndroid) {
      final huaweiAvailable = await _detectHuaweiStore();
      if (huaweiAvailable) {
        _isHuaweiStore = true;
        isStoreAvailable = true;
        // Check if already purchased on Huawei
        if (!isPremiumActive) {
          final owned =
              await HuaweiIapService.isProductOwned(removeAdsProductId);
          if (owned) {
            await _setPremiumActive(true);
          }
        }
        await loadProducts();
        return;
      }
    }

    lastMessageKey = PremiumMessageKey.storeUnavailable;
  }

  Future<void> loadProducts() async {
    if (!isStoreAvailable) return;

    isLoading = true;

    if (_isHuaweiStore) {
      huaweiProduct =
          await HuaweiIapService.queryProduct(removeAdsProductId);
      if (huaweiProduct == null) {
        lastMessageKey = PremiumMessageKey.productIdNotFound;
      } else {
        lastMessageKey = PremiumMessageKey.none;
      }
      isLoading = false;
      return;
    }

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

  Future<void> buyHuawei() async {
    final result = await HuaweiIapService.buy(removeAdsProductId);
    if (result.success) {
      await _setPremiumActive(true);
      lastMessageKey = PremiumMessageKey.paymentConfirmed;
    } else if (result.cancelled) {
      lastMessageKey = PremiumMessageKey.purchaseCancelled;
    } else {
      lastMessageKey = PremiumMessageKey.purchaseFailed;
      lastMessageExtra = result.errorMessage ?? '';
    }
  }

  Future<void> restorePurchases() async {
    if (_isHuaweiStore) {
      final owned =
          await HuaweiIapService.restorePurchase(removeAdsProductId);
      if (owned) {
        await _setPremiumActive(true);
        lastMessageKey = PremiumMessageKey.paymentConfirmed;
      }
      return;
    }
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
