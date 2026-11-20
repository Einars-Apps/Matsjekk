import 'package:in_app_purchase/in_app_purchase.dart';

import 'purchase_models.dart';

abstract class PlayCatalogApi {
  Future<CatalogQuery> queryLifetime(String productId);
  Future<PurchaseAttempt> buyLifetime(String productId);
  Future<void> restore();
}

class PluginPlayCatalogApi implements PlayCatalogApi {
  PluginPlayCatalogApi({InAppPurchase? iap}) : _iap = iap;

  InAppPurchase? _iap;
  ProductDetails? _product;

  InAppPurchase get _billing => _iap ??= InAppPurchase.instance;

  @override
  Future<CatalogQuery> queryLifetime(String productId) async {
    if (!await _billing.isAvailable()) {
      return const CatalogQuery(
        provider: StoreProviderId.googlePlay,
        failure: PurchaseFailure(
          PurchaseFailureKind.storeUnavailable,
          'Google Play Billing is not available.',
        ),
      );
    }
    final response = await _billing.queryProductDetails({productId});
    if (response.error != null) {
      return CatalogQuery(
        provider: StoreProviderId.googlePlay,
        failure: PurchaseFailure(
          PurchaseFailureKind.queryFailed,
          response.error!.message,
        ),
      );
    }
    if (response.productDetails.isEmpty) {
      _product = null;
      return CatalogQuery(
        provider: StoreProviderId.googlePlay,
        failure: PurchaseFailure(
          PurchaseFailureKind.emptyCatalog,
          'Google Play did not return $productId.',
        ),
      );
    }
    final product = response.productDetails.first;
    if (product.id != productId) {
      return CatalogQuery(
        provider: StoreProviderId.googlePlay,
        failure: PurchaseFailure(
          PurchaseFailureKind.productIdMismatch,
          'Google Play returned ${product.id}, expected $productId.',
        ),
      );
    }
    _product = product;
    return CatalogQuery(
      provider: StoreProviderId.googlePlay,
      offer: LifetimeOffer(
        productId: product.id,
        title: product.title,
        priceLabel: product.price,
        provider: StoreProviderId.googlePlay,
      ),
    );
  }

  @override
  Future<PurchaseAttempt> buyLifetime(String productId) async {
    final product = _product;
    if (product == null || product.id != productId) {
      return PurchaseAttempt.failed(PurchaseFailure(
        PurchaseFailureKind.emptyCatalog,
        'Google Play has no loaded product $productId.',
      ));
    }
    await _billing.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    return const PurchaseAttempt.submitted();
  }

  @override
  Future<void> restore() {
    return _billing.restorePurchases();
  }
}
