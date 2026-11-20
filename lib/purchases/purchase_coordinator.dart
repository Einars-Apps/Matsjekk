import 'dart:io' show Platform;

import 'huawei_iap_api.dart';
import 'huawei_channel_api.dart';
import 'huawei_signature.dart';
import 'play_catalog_api.dart';
import 'purchase_models.dart';

const lifetimeProductId = lifetimeRemoveAdsProductId;

StoreProviderId storeProviderFromEnvironment() {
  const requested = String.fromEnvironment('PURCHASE_PROVIDER');
  switch (requested) {
    case 'huawei':
      return StoreProviderId.huaweiAppGallery;
    case 'google_play':
      return StoreProviderId.googlePlay;
    case 'app_store':
      return StoreProviderId.appStore;
    default:
      if (Platform.isIOS) return StoreProviderId.appStore;
      return StoreProviderId.googlePlay;
  }
}

/// The Android product flavor wins over a missing or Play dart-define.
/// A Play-flavored build that was explicitly compiled as Huawei still stays
/// on Huawei, so it cannot fall through to a Play catalog query.
StoreProviderId providerForBuild({
  required StoreProviderId environment,
  String? androidStoreFlavor,
}) {
  if (androidStoreFlavor == 'huawei') return StoreProviderId.huaweiAppGallery;
  return environment;
}

class PurchaseCoordinator {
  PurchaseCoordinator({
    required this.provider,
    required this.verifier,
    this.huawei,
    this.play,
    required this.readEntitled,
    required this.writeEntitled,
  });

  static Future<PurchaseCoordinator> production({
    required bool Function() readEntitled,
    required Future<void> Function(bool value) writeEntitled,
  }) async {
    final environment = storeProviderFromEnvironment();
    final flavor = Platform.isAndroid ? await HuaweiChannelApi().storeFlavor() : null;
    final provider = providerForBuild(
      environment: environment,
      androidStoreFlavor: flavor,
    );
    const publicKey = String.fromEnvironment('HUAWEI_IAP_PUBLIC_KEY');
    return PurchaseCoordinator(
      provider: provider,
      verifier: HuaweiSignatureVerifier.fromSpki(publicKey),
      huawei: provider == StoreProviderId.huaweiAppGallery
          ? HuaweiChannelApi()
          : null,
      play: provider == StoreProviderId.huaweiAppGallery
          ? null
          : PluginPlayCatalogApi(),
      readEntitled: readEntitled,
      writeEntitled: writeEntitled,
    );
  }

  final StoreProviderId provider;
  final HuaweiSignatureVerifier verifier;
  final HuaweiIapApi? huawei;
  final PlayCatalogApi? play;
  final bool Function() readEntitled;
  final Future<void> Function(bool value) writeEntitled;

  int playQueryCount = 0;

  Future<CatalogQuery> load() async {
    switch (provider) {
      case StoreProviderId.huaweiAppGallery:
        return _loadHuawei();
      case StoreProviderId.googlePlay:
      case StoreProviderId.appStore:
        playQueryCount += 1;
        return play!.queryLifetime(lifetimeProductId);
    }
  }

  Future<PurchaseAttempt> buy() async {
    if (provider == StoreProviderId.huaweiAppGallery) {
      return _buyHuawei();
    }
    return play!.buyLifetime(lifetimeProductId);
  }

  Future<RestoreAttempt> restore() async {
    final already = readEntitled();
    if (provider != StoreProviderId.huaweiAppGallery) {
      await play!.restore();
      return const RestoreAttempt(RestoreKind.submitted);
    }
    final response = await huawei!.restore();
    if (response.status != 'ok') {
      if (already) return const RestoreAttempt(RestoreKind.preserved);
      return RestoreAttempt(
        RestoreKind.failed,
        failure: _failureFromHuawei(response),
      );
    }
    for (final owned in response.owned) {
      final verdict = verifier.verify(
        signedData: owned.signedData,
        signatureBase64: owned.signature,
        expectedProductId: lifetimeProductId,
      );
      if (verdict.valid) {
        await writeEntitled(true);
        return const RestoreAttempt(RestoreKind.granted);
      }
    }
    if (already) return const RestoreAttempt(RestoreKind.preserved);
    if (response.owned.isEmpty) {
      return const RestoreAttempt(RestoreKind.notOwned);
    }
    return const RestoreAttempt(
      RestoreKind.failed,
      failure: PurchaseFailure(
        PurchaseFailureKind.verificationRejected,
        'Owned Huawei purchases did not verify.',
      ),
    );
  }

  Future<CatalogQuery> _loadHuawei() async {
    final response = await huawei!.query(lifetimeProductId);
    if (response.status != 'ok') {
      return CatalogQuery(
        provider: provider,
        failure: _failureFromHuawei(response) ??
            const PurchaseFailure(
              PurchaseFailureKind.queryFailed,
              'Huawei IAP failed.',
            ),
      );
    }
    return CatalogQuery(
      provider: provider,
      offer: LifetimeOffer(
        productId: lifetimeProductId,
        title: response.title?.isNotEmpty == true
            ? response.title!
            : lifetimeProductId,
        priceLabel: response.price ?? '',
        provider: StoreProviderId.huaweiAppGallery,
      ),
    );
  }

  Future<PurchaseAttempt> _buyHuawei() async {
    final response = await huawei!.buy(lifetimeProductId);
    if (response.status == 'cancelled') {
      return const PurchaseAttempt.failed(PurchaseFailure(
        PurchaseFailureKind.cancelled,
        'Huawei purchase was cancelled.',
      ));
    }
    final failure = _failureFromHuawei(response);
    if (failure != null) return PurchaseAttempt.failed(failure);
    final verdict = verifier.verify(
      signedData: response.signedData ?? '',
      signatureBase64: response.signature ?? '',
      expectedProductId: lifetimeProductId,
    );
    if (!verdict.valid) {
      return PurchaseAttempt.failed(verdict.failure!);
    }
    await writeEntitled(true);
    return const PurchaseAttempt.granted();
  }

  PurchaseFailure? _failureFromHuawei(HuaweiIapResponse response) {
    switch (response.status) {
      case 'ok':
        return null;
      case 'empty':
        return const PurchaseFailure(
          PurchaseFailureKind.emptyCatalog,
          'Huawei IAP did not return $lifetimeProductId.',
        );
      case 'unavailable':
        return PurchaseFailure(
          PurchaseFailureKind.storeUnavailable,
          response.message ?? 'HMS IAP is not available on this device.',
        );
      case 'notConfigured':
        return PurchaseFailure(
          PurchaseFailureKind.notConfigured,
          response.message ?? 'Huawei IAP configuration is missing.',
          missing: response.missing,
        );
      case 'cancelled':
        return const PurchaseFailure(
          PurchaseFailureKind.cancelled,
          'Huawei purchase was cancelled.',
        );
      default:
        return PurchaseFailure(
          PurchaseFailureKind.queryFailed,
          response.message ?? 'Huawei IAP failed.',
        );
    }
  }
}
