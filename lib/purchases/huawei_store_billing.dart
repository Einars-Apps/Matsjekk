import 'dart:async';
import 'dart:convert';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../premium_service.dart';
import 'huawei_channel_api.dart';
import 'huawei_iap_api.dart';
import 'huawei_signature.dart';

/// Public IAP key from AppGallery Connect (Earn > In-App Purchases), passed
/// with `--dart-define=HUAWEI_IAP_PUBLIC_KEY=...` for the huawei flavor.
/// It is a public key, but it is kept out of git with the other AGC config.
/// Without it no Huawei purchase is granted (fail closed).
const String kHuaweiIapPublicKey = String.fromEnvironment('HUAWEI_IAP_PUBLIC_KEY');

const String kHuaweiSource = 'huawei_appgallery';

/// [StoreBilling] backed by HMS IAP through the `com.ebors.matsjekk/hms_iap`
/// channel (huawei flavor only). Emits the same [PurchaseDetails] stream
/// [PremiumService] already understands, so the ad-free rules are shared:
/// `premium_adfree` is sold, `matsjekk_remove_ads_lifetime` is still accepted
/// on restore.
///
/// A purchase is emitted as purchased/restored only after the SHA256withRSA
/// signature verifies against [kHuaweiIapPublicKey] and Huawei reports
/// `purchaseState == 0` for an accepted product id.
class HuaweiStoreBilling implements StoreBilling {
  HuaweiStoreBilling({
    HuaweiIapApi? api,
    HuaweiSignatureVerifier? verifier,
  })  : _api = api ?? HuaweiChannelApi(),
        _verifier = verifier ?? HuaweiSignatureVerifier.fromSpki(kHuaweiIapPublicKey);

  final HuaweiIapApi _api;
  final HuaweiSignatureVerifier _verifier;
  final StreamController<List<PurchaseDetails>> _controller =
      StreamController<List<PurchaseDetails>>.broadcast(sync: true);

  /// Last HMS status/message, for diagnostics in the premium screen.
  String lastStatus = '';

  @override
  Future<bool> isAvailable() async {
    final r = await _api.query(PremiumService.huaweiRemoveAdsProductId);
    lastStatus = '${r.status}${r.message == null ? '' : ': ${r.message}'}';
    // `empty` means HMS answered but the product is not set up in AGC: the
    // store is reachable, PremiumService then reports the missing product.
    return r.status == 'ok' || r.status == 'empty';
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _controller.stream;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) async {
    final found = <ProductDetails>[];
    final missing = <String>[];
    IAPError? error;
    for (final id in identifiers) {
      final r = await _api.query(id);
      if (r.status == 'ok') {
        found.add(ProductDetails(
          id: id,
          title: r.title ?? '',
          description: '',
          price: r.price ?? '',
          rawPrice: 0,
          currencyCode: '',
        ));
      } else {
        missing.add(id);
        if (r.status != 'empty') {
          error = IAPError(source: kHuaweiSource, code: r.status, message: r.message ?? r.status);
        }
      }
    }
    return ProductDetailsResponse(productDetails: found, notFoundIDs: missing, error: error);
  }

  @override
  Future<void> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    final id = purchaseParam.productDetails.id;
    final r = await _api.buy(id);
    switch (r.status) {
      case 'ok':
        _controller.add([_verified(r.signedData ?? '', r.signature ?? '', PurchaseStatus.purchased)]);
      case 'owned':
        // Huawei says this ID already owns it: restore instead of a new order.
        await restorePurchases();
      case 'cancelled':
        _controller.add([_failure(id, PurchaseStatus.canceled, 'cancelled')]);
      default:
        _controller.add([_failure(id, PurchaseStatus.error, r.message ?? r.status)]);
    }
  }

  @override
  Future<void> restorePurchases() async {
    final r = await _api.restore();
    if (r.status != 'ok') {
      throw StateError('Huawei restore ${r.status}: ${r.message ?? ''}');
    }
    final out = <PurchaseDetails>[];
    for (final owned in r.owned) {
      final p = _verified(owned.signedData, owned.signature, PurchaseStatus.restored);
      if (p.status == PurchaseStatus.restored) out.add(p);
    }
    if (out.isNotEmpty) _controller.add(out);
  }

  /// Non-consumable: nothing to consume or acknowledge on HMS.
  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  PurchaseDetails _verified(String signedData, String signature, PurchaseStatus ok) {
    final productId = productIdOf(signedData);
    if (!PremiumService.adFreeEntitlementIds.contains(productId)) {
      return _failure(productId, PurchaseStatus.error, 'Huawei returned unknown product $productId');
    }
    final v = _verifier.verify(
      signedData: signedData,
      signatureBase64: signature,
      expectedProductId: productId,
    );
    if (!v.valid) {
      return _failure(productId, PurchaseStatus.error, v.failure?.message ?? 'verification failed');
    }
    return PurchaseDetails(
      purchaseID: v.purchaseToken,
      productID: productId,
      verificationData: PurchaseVerificationData(
        localVerificationData: signedData,
        serverVerificationData: signature,
        source: kHuaweiSource,
      ),
      transactionDate: null,
      status: ok,
    );
  }

  PurchaseDetails _failure(String productId, PurchaseStatus status, String message) {
    return PurchaseDetails(
      productID: productId,
      verificationData: PurchaseVerificationData(
        localVerificationData: '',
        serverVerificationData: '',
        source: kHuaweiSource,
      ),
      transactionDate: null,
      status: status,
    )..error = status == PurchaseStatus.error
        ? IAPError(source: kHuaweiSource, code: 'huawei', message: message)
        : null;
  }

  static String productIdOf(String signedData) {
    try {
      final m = jsonDecode(signedData);
      return m is Map ? (m['productId']?.toString() ?? '') : '';
    } catch (_) {
      return '';
    }
  }
}

/// Picks HMS IAP when the native side is the huawei flavor, else Play/App Store.
/// The flavor comes from the `flavor` call on the HMS channel; the play
/// flavor answers `play`, iOS has no channel (null).
class FlavorStoreBilling implements StoreBilling {
  FlavorStoreBilling({
    StoreBilling? play,
    StoreBilling Function()? huawei,
    Future<String?> Function()? flavor,
  })  : _play = play ?? PluginStoreBilling(),
        _huaweiFactory = huawei ?? (() => HuaweiStoreBilling()),
        _flavor = flavor ?? (() => HuaweiChannelApi().storeFlavor());

  final StoreBilling _play;
  final StoreBilling Function() _huaweiFactory;
  final Future<String?> Function() _flavor;
  StoreBilling? _active;

  bool isHuawei = false;

  Future<StoreBilling> _resolve() async {
    final active = _active;
    if (active != null) return active;
    isHuawei = (await _flavor()) == 'huawei';
    return _active = isHuawei ? _huaweiFactory() : _play;
  }

  @override
  Future<bool> isAvailable() async => (await _resolve()).isAvailable();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => (_active ?? _play).purchaseStream;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) async =>
      (await _resolve()).queryProductDetails(identifiers);

  @override
  Future<void> buyNonConsumable({required PurchaseParam purchaseParam}) async =>
      (await _resolve()).buyNonConsumable(purchaseParam: purchaseParam);

  @override
  Future<void> restorePurchases() async => (await _resolve()).restorePurchases();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async =>
      (await _resolve()).completePurchase(purchase);
}
