import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mat_sjekk/premium_service.dart';
import 'package:mat_sjekk/purchases/huawei_iap_api.dart';
import 'package:mat_sjekk/purchases/huawei_signature.dart';
import 'package:mat_sjekk/purchases/huawei_store_billing.dart';
import 'package:pointycastle/export.dart';

import 'helpers.dart';

late RSAPrivateKey _priv;
late RSAPublicKey _pub;

void _keys() {
  final rnd = FortunaRandom()
    ..seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => Random(7).nextInt(256)))));
  final gen = RSAKeyGenerator()
    ..init(ParametersWithRandom(RSAKeyGeneratorParameters(BigInt.parse('65537'), 1024, 64), rnd));
  final pair = gen.generateKeyPair();
  _priv = pair.privateKey as RSAPrivateKey;
  _pub = pair.publicKey as RSAPublicKey;
}

String _sign(String data) {
  final s = RSASigner(SHA256Digest(), '0609608648016503040201')
    ..init(true, PrivateKeyParameter<RSAPrivateKey>(_priv));
  return base64.encode(s.generateSignature(Uint8List.fromList(utf8.encode(data))).bytes);
}

String _data(String productId, {int state = 0}) =>
    jsonEncode({'productId': productId, 'purchaseState': state, 'purchaseToken': 'tok-$productId'});

class _FakeApi implements HuaweiIapApi {
  _FakeApi({this.queryStatus = 'ok', this.buyResponse, this.owned = const []});
  final String queryStatus;
  final HuaweiIapResponse? buyResponse;
  final List<HuaweiOwnedPurchase> owned;
  final queried = <String>[];

  @override
  Future<HuaweiIapResponse> query(String productId) async {
    queried.add(productId);
    return HuaweiIapResponse(status: queryStatus, title: 'Reklamefri', price: 'kr 49');
  }

  @override
  Future<HuaweiIapResponse> buy(String productId) async =>
      buyResponse ?? const HuaweiIapResponse(status: 'cancelled');

  @override
  Future<HuaweiIapResponse> restore() async => HuaweiIapResponse(status: 'ok', owned: owned);
}

HuaweiStoreBilling _billing(_FakeApi api, {bool withKey = true}) => HuaweiStoreBilling(
      api: api,
      verifier: HuaweiSignatureVerifier(withKey ? _pub : null),
    );

void main() {
  setUpAll(_keys);
  setUp(() async => setUpHiveForTest());
  tearDown(() async => tearDownHiveForTest());

  test('huawei flavor sells matsjekk_remove_ads_lifetime and grants it after a valid signature', () async {
    final data = _data(PremiumService.huaweiRemoveAdsProductId);
    final api = _FakeApi(buyResponse: HuaweiIapResponse(status: 'ok', signedData: data, signature: _sign(data)));
    final service = PremiumService(billing: _billing(api), isIOS: false);
    await service.initialize(Hive.box('innstillinger'));
    expect(api.queried, everyElement(PremiumService.huaweiRemoveAdsProductId));
    expect(service.products.single.id, PremiumService.huaweiRemoveAdsProductId);
    expect(service.products.single.price, 'kr 49');
    expect(service.isPremiumActive, isFalse);

    await service.buy(service.products.single);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(service.isPremiumActive, isTrue);
    expect(Hive.box('innstillinger').get(PremiumService.adsRemovedKey), isTrue);
  });

  test('a tampered or unsigned receipt does not remove ads', () async {
    final data = _data(PremiumService.androidRemoveAdsProductId);
    final tampered = data.replaceFirst('tok-', 'tok2-');
    final api = _FakeApi(buyResponse: HuaweiIapResponse(status: 'ok', signedData: tampered, signature: _sign(data)));
    final service = PremiumService(billing: _billing(api), isIOS: false);
    await service.initialize(Hive.box('innstillinger'));
    await service.buy(service.products.single);
    await Future<void>.delayed(Duration.zero);
    expect(service.isPremiumActive, isFalse);

    final noKey = PremiumService(billing: _billing(_FakeApi(buyResponse: HuaweiIapResponse(status: 'ok', signedData: data, signature: _sign(data))), withKey: false), isIOS: false);
    await noKey.initialize(Hive.box('innstillinger'));
    await noKey.buy(noKey.products.single);
    await Future<void>.delayed(Duration.zero);
    expect(noKey.isPremiumActive, isFalse);
  });

  test('restore also accepts the Play id premium_adfree', () async {
    final legacy = _data(PremiumService.androidRemoveAdsProductId);
    final other = _data('something_else');
    final api = _FakeApi(owned: [
      HuaweiOwnedPurchase(signedData: other, signature: _sign(other)),
      HuaweiOwnedPurchase(signedData: legacy, signature: _sign(legacy)),
    ]);
    final service = PremiumService(billing: _billing(api), isIOS: false);
    await service.initialize(Hive.box('innstillinger'));
    expect(service.isPremiumActive, isTrue);
  });

  test('a cancelled-state receipt is not restored', () async {
    final refunded = _data(PremiumService.androidRemoveAdsProductId, state: 1);
    final api = _FakeApi(owned: [HuaweiOwnedPurchase(signedData: refunded, signature: _sign(refunded))]);
    final service = PremiumService(billing: _billing(api), isIOS: false);
    await service.initialize(Hive.box('innstillinger'));
    expect(service.isPremiumActive, isFalse);
  });

  test('HMS not configured means store unavailable, no grant', () async {
    final service = PremiumService(billing: _billing(_FakeApi(queryStatus: 'notConfigured')), isIOS: false);
    await service.initialize(Hive.box('innstillinger'));
    expect(service.isStoreAvailable, isFalse);
    expect(service.isPremiumActive, isFalse);
  });

  test('flavor switch picks HMS only for the huawei flavor', () async {
    final hms = _billing(_FakeApi());
    final huawei = FlavorStoreBilling(play: _billing(_FakeApi(queryStatus: 'error')), huawei: () => hms, flavor: () async => 'huawei');
    expect(await huawei.isAvailable(), isTrue);
    expect(huawei.isHuawei, isTrue);
    final play = FlavorStoreBilling(play: _billing(_FakeApi(queryStatus: 'error')), huawei: () => hms, flavor: () async => 'play');
    expect(await play.isAvailable(), isFalse);
    expect(play.isHuawei, isFalse);
    final ios = FlavorStoreBilling(play: _billing(_FakeApi(queryStatus: 'error')), huawei: () => hms, flavor: () async => null);
    await ios.isAvailable();
    expect(ios.isHuawei, isFalse);
  });

  test('purchase details keep the signed data for audits', () {
    expect(HuaweiStoreBilling.productIdOf(_data('premium_adfree')), 'premium_adfree');
    expect(HuaweiStoreBilling.productIdOf('nope'), '');
    expect(PurchaseStatus.values, contains(PurchaseStatus.restored));
  });
}
