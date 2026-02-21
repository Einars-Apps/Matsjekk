import 'dart:async';

import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumService {
  static const String monthlyProductId = 'matsjekk_premium_monthly';
  static const String yearlyProductId = 'matsjekk_premium_yearly';
  static const String premiumActiveKey = 'premiumActive';

  final InAppPurchase _iap = InAppPurchase.instance;

  Box? _settingsBox;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool isStoreAvailable = false;
  bool isPremiumActive = false;
  bool isLoading = false;
  String lastMessage = '';
  List<ProductDetails> products = [];

  Future<void> initialize(Box settingsBox) async {
    _settingsBox = settingsBox;
    isPremiumActive = settingsBox.get(premiumActiveKey, defaultValue: false);

    isStoreAvailable = await _iap.isAvailable();
    if (!isStoreAvailable) {
      lastMessage = 'Butikk utilgjengelig akkurat nå. Prøv igjen senere.';
      return;
    }

    _purchaseSubscription?.cancel();
    _purchaseSubscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        lastMessage = 'Kjøpsstrøm feilet: $error';
      },
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    if (!isStoreAvailable) return;

    isLoading = true;
    final response = await _iap.queryProductDetails(
      {monthlyProductId, yearlyProductId},
    );

    products = response.productDetails.toList()
      ..sort((a, b) => a.price.compareTo(b.price));

    if (response.error != null) {
      lastMessage = 'Kunne ikke hente produkter: ${response.error!.message}';
    } else if (products.isEmpty) {
      lastMessage =
          'Ingen premium-produkter funnet. Sjekk produkt-ID i Play/App Store.';
    } else {
      lastMessage = '';
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
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        await _setPremiumActive(true);
        lastMessage = 'Premium er aktivert.';
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        lastMessage =
            purchaseDetails.error?.message ?? 'Kjøpet feilet. Prøv igjen.';
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _setPremiumActive(bool value) async {
    isPremiumActive = value;
    await _settingsBox?.put(premiumActiveKey, value);
  }

  Future<void> dispose() async {
    await _purchaseSubscription?.cancel();
  }
}
