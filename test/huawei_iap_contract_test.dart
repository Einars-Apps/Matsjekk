import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/premium_service.dart';
import 'package:mat_sjekk/purchases/huawei_iap_api.dart';
import 'package:mat_sjekk/purchases/huawei_signature.dart';
import 'package:mat_sjekk/purchases/play_catalog_api.dart';
import 'package:mat_sjekk/purchases/purchase_coordinator.dart';
import 'package:mat_sjekk/purchases/purchase_models.dart';
import 'package:pointycastle/export.dart';

void main() {
  test('huawei flavor source calls HMS and the play flavor does not', () {
    final huawei = File(
      'android/app/src/huawei/kotlin/com/example/mat_sjekk/HmsIapBridge.kt',
    ).readAsStringSync();
    final play = File(
      'android/app/src/play/kotlin/com/example/mat_sjekk/HmsIapBridge.kt',
    ).readAsStringSync();
    expect(huawei, contains('obtainProductInfo'));
    expect(huawei, contains('createPurchaseIntent'));
    expect(huawei, contains('obtainOwnedPurchases'));
    expect(huawei, contains('IN_APP_NONCONSUMABLE'));
    expect(huawei, contains('inAppSignature'));
    expect(huawei, isNot(contains('BillingClient')));
    expect(huawei, contains('result.success("huawei")'));
    expect(play, contains('notConfigured'));
    expect(play, contains('result.success("play")'));
    expect(play, isNot(contains('Iap.getIapClient')));
  });

  test('huawei flavor selects HMS even when the dart-define is Play', () {
    expect(
      providerForBuild(
        environment: StoreProviderId.googlePlay,
        androidStoreFlavor: 'huawei',
      ),
      StoreProviderId.huaweiAppGallery,
    );
    expect(
      providerForBuild(
        environment: StoreProviderId.huaweiAppGallery,
        androidStoreFlavor: 'play',
      ),
      StoreProviderId.huaweiAppGallery,
    );
    expect(
      providerForBuild(
        environment: StoreProviderId.googlePlay,
        androidStoreFlavor: 'play',
      ),
      StoreProviderId.googlePlay,
    );
  });

  test('empty Huawei catalog does not query Google Play or grant', () async {
    final play = _SpyPlay();
    var entitled = false;
    final coordinator = PurchaseCoordinator(
      provider: StoreProviderId.huaweiAppGallery,
      verifier: const HuaweiSignatureVerifier(null),
      huawei: _ScriptedHuawei(
        queryResult: const HuaweiIapResponse(status: 'empty'),
      ),
      play: play,
      readEntitled: () => entitled,
      writeEntitled: (value) async => entitled = value,
    );
    final catalog = await coordinator.load();
    expect(play.queries, 0);
    expect(catalog.failure?.kind, PurchaseFailureKind.emptyCatalog);
    expect(entitled, isFalse);
    expect(coordinator.playQueryCount, 0);
  });

  test('HMS unavailable and missing config do not grant', () async {
    for (final status in ['unavailable', 'notConfigured', 'error']) {
      var entitled = true;
      final coordinator = PurchaseCoordinator(
        provider: StoreProviderId.huaweiAppGallery,
        verifier: const HuaweiSignatureVerifier(null),
        huawei: _ScriptedHuawei(
          queryResult: HuaweiIapResponse(
            status: status,
            missing: status == 'notConfigured' ? ['android/huawei.properties appId'] : const [],
          ),
        ),
        readEntitled: () => entitled,
        writeEntitled: (value) async => entitled = value,
      );
      final catalog = await coordinator.load();
      expect(catalog.offer, isNull);
      expect(entitled, isTrue, reason: status);
    }
  });

  test('unverified Huawei purchase does not grant and keeps an existing right', () async {
    final keys = _rsaKeys();
    final signed = jsonEncode({
      'productId': PremiumService.removeAdsProductId,
      'purchaseState': 0,
      'purchaseToken': 'token-1',
    });
    final signature = base64.encode(_sign(keys.privateKey, signed));
    var entitled = true;
    final coordinator = PurchaseCoordinator(
      provider: StoreProviderId.huaweiAppGallery,
      verifier: const HuaweiSignatureVerifier(null),
      huawei: _ScriptedHuawei(
        buyResult: HuaweiIapResponse(
          status: 'ok',
          signedData: signed,
          signature: signature,
        ),
      ),
      readEntitled: () => entitled,
      writeEntitled: (value) async => entitled = value,
    );
    final attempt = await coordinator.buy();
    expect(attempt.kind, PurchaseAttemptKind.failed);
    expect(attempt.failure?.kind, PurchaseFailureKind.verificationNotConfigured);
    expect(entitled, isTrue);

    final wrongKey = PurchaseCoordinator(
      provider: StoreProviderId.huaweiAppGallery,
      verifier: HuaweiSignatureVerifier(keys.otherPublic),
      huawei: _ScriptedHuawei(
        buyResult: HuaweiIapResponse(
          status: 'ok',
          signedData: signed,
          signature: signature,
        ),
      ),
      readEntitled: () => false,
      writeEntitled: (value) async {},
    );
    final rejected = await wrongKey.buy();
    expect(rejected.failure?.kind, PurchaseFailureKind.verificationRejected);
  });

  test('verified signature grants only the lifetime product and restore repeats it', () async {
    final keys = _rsaKeys();
    final signed = jsonEncode({
      'productId': PremiumService.removeAdsProductId,
      'purchaseState': 0,
      'purchaseToken': 'token-ok',
    });
    final signature = base64.encode(_sign(keys.privateKey, signed));
    final otherProduct = jsonEncode({
      'productId': 'other_product',
      'purchaseState': 0,
      'purchaseToken': 'nope',
    });
    var entitled = false;
    final huawei = _ScriptedHuawei(
      queryResult: const HuaweiIapResponse(
        status: 'ok',
        title: 'Remove ads',
        price: 'CNY 35.26',
      ),
      buyResult: HuaweiIapResponse(
        status: 'ok',
        signedData: signed,
        signature: signature,
      ),
      restoreResult: HuaweiIapResponse(
        status: 'ok',
        owned: [
          HuaweiOwnedPurchase(
            signedData: otherProduct,
            signature: base64.encode(_sign(keys.privateKey, otherProduct)),
          ),
          HuaweiOwnedPurchase(signedData: signed, signature: signature),
        ],
      ),
    );
    final coordinator = PurchaseCoordinator(
      provider: StoreProviderId.huaweiAppGallery,
      verifier: HuaweiSignatureVerifier(keys.publicKey),
      huawei: huawei,
      readEntitled: () => entitled,
      writeEntitled: (value) async => entitled = value,
    );
    final catalog = await coordinator.load();
    expect(catalog.offer?.productId, PremiumService.removeAdsProductId);
    expect(catalog.offer?.priceLabel, 'CNY 35.26');
    expect(await coordinator.buy(), const PurchaseAttempt.granted());
    expect(entitled, isTrue);

    entitled = false;
    expect((await coordinator.restore()).kind, RestoreKind.granted);
    expect(entitled, isTrue);
    expect(huawei.buyProductIds, [PremiumService.removeAdsProductId]);
  });

  test('cancelled purchase and refunded state do not grant', () async {
    final keys = _rsaKeys();
    final refunded = jsonEncode({
      'productId': PremiumService.removeAdsProductId,
      'purchaseState': 2,
      'purchaseToken': 'refunded',
    });
    var entitled = false;
    final coordinator = PurchaseCoordinator(
      provider: StoreProviderId.huaweiAppGallery,
      verifier: HuaweiSignatureVerifier(keys.publicKey),
      huawei: _ScriptedHuawei(
        buyResult: const HuaweiIapResponse(status: 'cancelled'),
        restoreResult: HuaweiIapResponse(
          status: 'ok',
          owned: [
            HuaweiOwnedPurchase(
              signedData: refunded,
              signature: base64.encode(_sign(keys.privateKey, refunded)),
            ),
          ],
        ),
      ),
      readEntitled: () => entitled,
      writeEntitled: (value) async => entitled = value,
    );
    expect((await coordinator.buy()).failure?.kind, PurchaseFailureKind.cancelled);
    expect((await coordinator.restore()).kind, RestoreKind.failed);
    expect(entitled, isFalse);
  });

  test('SPKI public key round trip verifies SHA256withRSA', () {
    final keys = _rsaKeys();
    final spki = spkiFromPublicKey(keys.publicKey);
    final parsed = rsaPublicKeyFromSpki(spki);
    const message = '{"productId":"matsjekk_remove_ads_lifetime","purchaseState":0}';
    final signature = base64.encode(_sign(keys.privateKey, message));
    final verdict = HuaweiSignatureVerifier(parsed).verify(
      signedData: message,
      signatureBase64: signature,
      expectedProductId: 'matsjekk_remove_ads_lifetime',
    );
    expect(verdict.valid, isTrue);
  });
}

class _SpyPlay implements PlayCatalogApi {
  int queries = 0;

  @override
  Future<PurchaseAttempt> buyLifetime(String productId) async {
    return const PurchaseAttempt.failed(PurchaseFailure(
      PurchaseFailureKind.queryFailed,
      'play buy should not run',
    ));
  }

  @override
  Future<CatalogQuery> queryLifetime(String productId) async {
    queries += 1;
    return const CatalogQuery(provider: StoreProviderId.googlePlay);
  }

  @override
  Future<void> restore() async {}
}

class _ScriptedHuawei implements HuaweiIapApi {
  _ScriptedHuawei({
    this.queryResult = const HuaweiIapResponse(status: 'empty'),
    this.buyResult = const HuaweiIapResponse(status: 'error'),
    this.restoreResult = const HuaweiIapResponse(status: 'ok'),
  });

  final HuaweiIapResponse queryResult;
  final HuaweiIapResponse buyResult;
  final HuaweiIapResponse restoreResult;
  final List<String> buyProductIds = [];

  @override
  Future<HuaweiIapResponse> buy(String productId) async {
    buyProductIds.add(productId);
    return buyResult;
  }

  @override
  Future<HuaweiIapResponse> query(String productId) async => queryResult;

  @override
  Future<HuaweiIapResponse> restore() async => restoreResult;
}

class _RsaKeys {
  _RsaKeys(this.publicKey, this.privateKey, this.otherPublic);
  final RSAPublicKey publicKey;
  final RSAPrivateKey privateKey;
  final RSAPublicKey otherPublic;
}

_RsaKeys _rsaKeys() {
  final first = _generate(1);
  final second = _generate(2);
  return _RsaKeys(
    first.publicKey as RSAPublicKey,
    first.privateKey as RSAPrivateKey,
    second.publicKey as RSAPublicKey,
  );
}

AsymmetricKeyPair<PublicKey, PrivateKey> _generate(int seed) {
  final secureRandom = FortunaRandom()
    ..seed(KeyParameter(
      Uint8List.fromList(List.generate(32, (i) => Random(seed * 1000 + i).nextInt(255))),
    ));
  final generator = RSAKeyGenerator()
    ..init(ParametersWithRandom(
      RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64),
      secureRandom,
    ));
  return generator.generateKeyPair();
}

Uint8List _sign(RSAPrivateKey key, String message) {
  final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
  signer.init(true, PrivateKeyParameter<RSAPrivateKey>(key));
  return signer.generateSignature(Uint8List.fromList(utf8.encode(message))).bytes;
}
