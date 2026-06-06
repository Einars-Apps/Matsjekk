import 'package:huawei_iap/huawei_iap.dart';

/// Wrapper around Huawei IAP SDK for non-consumable purchases.
class HuaweiIapService {
  static const int productTypeNonConsumable = 1;

  /// Check if HMS IAP environment is ready (i.e. Huawei device with HMS Core).
  static Future<bool> isAvailable() async {
    try {
      final result = await IapClient.isEnvReady();
      return result.returnCode == '0';
    } catch (_) {
      return false;
    }
  }

  /// Query product details from Huawei IAP.
  static Future<HuaweiProduct?> queryProduct(String productId) async {
    try {
      final request = ProductInfoReq(
        priceType: productTypeNonConsumable,
        skuIds: [productId],
      );
      final result = await IapClient.obtainProductInfo(request);
      if (result.productInfoList != null &&
          result.productInfoList!.isNotEmpty) {
        final info = result.productInfoList!.first;
        return HuaweiProduct(
          productId: info.productId ?? productId,
          title: info.productName ?? productId,
          price: info.price ?? '',
          priceRaw: info.microsPrice ?? 0,
          currency: info.currency ?? '',
        );
      }
    } catch (_) {}
    return null;
  }

  /// Initiate a non-consumable purchase on Huawei.
  static Future<HuaweiPurchaseResult> buy(String productId) async {
    try {
      final request = PurchaseIntentReq(
        priceType: productTypeNonConsumable,
        productId: productId,
      );
      final result = await IapClient.createPurchaseIntent(request);
      if (result.returnCode == '0' || result.returnCode == null) {
        return HuaweiPurchaseResult(success: true);
      }
      if (result.returnCode == '-1') {
        return HuaweiPurchaseResult(success: false, cancelled: true);
      }
      return HuaweiPurchaseResult(
        success: false,
        errorMessage: 'Huawei IAP error code: ${result.returnCode}',
      );
    } catch (e) {
      return HuaweiPurchaseResult(
        success: false,
        errorMessage: '$e',
      );
    }
  }

  /// Check if the user already owns a non-consumable product.
  static Future<bool> isProductOwned(String productId) async {
    try {
      final request = OwnedPurchasesReq(
        priceType: productTypeNonConsumable,
      );
      final result = await IapClient.obtainOwnedPurchases(request);
      if (result.inAppPurchaseDataList != null) {
        for (final data in result.inAppPurchaseDataList!) {
          if (data.productId == productId) {
            return true;
          }
        }
      }
    } catch (_) {}
    return false;
  }

  /// Restore purchases — checks owned non-consumable products.
  static Future<bool> restorePurchase(String productId) async {
    return isProductOwned(productId);
  }
}

/// Simplified product info for Huawei products.
class HuaweiProduct {
  final String productId;
  final String title;
  final String price;
  final int priceRaw;
  final String currency;

  HuaweiProduct({
    required this.productId,
    required this.title,
    required this.price,
    required this.priceRaw,
    required this.currency,
  });
}

/// Result of a Huawei purchase attempt.
class HuaweiPurchaseResult {
  final bool success;
  final bool cancelled;
  final String? errorMessage;

  HuaweiPurchaseResult({
    required this.success,
    this.cancelled = false,
    this.errorMessage,
  });
}
