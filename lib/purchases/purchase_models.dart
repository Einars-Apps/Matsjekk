const lifetimeRemoveAdsProductId = 'matsjekk_remove_ads_lifetime';

enum StoreProviderId {
  googlePlay,
  appStore,
  huaweiAppGallery,
}

enum PurchaseFailureKind {
  notConfigured,
  storeUnavailable,
  emptyCatalog,
  queryFailed,
  cancelled,
  verificationNotConfigured,
  verificationRejected,
  productIdMismatch,
}

class PurchaseFailure {
  final PurchaseFailureKind kind;
  final String message;
  final List<String> missing;

  const PurchaseFailure(this.kind, this.message, {this.missing = const []});
}

class LifetimeOffer {
  final String productId;
  final String title;
  final String priceLabel;
  final StoreProviderId provider;

  const LifetimeOffer({
    required this.productId,
    required this.title,
    required this.priceLabel,
    required this.provider,
  });
}

class CatalogQuery {
  final StoreProviderId provider;
  final LifetimeOffer? offer;
  final PurchaseFailure? failure;

  const CatalogQuery({required this.provider, this.offer, this.failure});

  bool get isReady => offer != null && failure == null;
}

enum PurchaseAttemptKind { submitted, granted, failed }

class PurchaseAttempt {
  final PurchaseAttemptKind kind;
  final PurchaseFailure? failure;

  const PurchaseAttempt._(this.kind, this.failure);

  const PurchaseAttempt.submitted() : this._(PurchaseAttemptKind.submitted, null);

  const PurchaseAttempt.granted() : this._(PurchaseAttemptKind.granted, null);

  const PurchaseAttempt.failed(PurchaseFailure failure)
      : this._(PurchaseAttemptKind.failed, failure);
}

enum RestoreKind { submitted, granted, preserved, notOwned, failed }

class RestoreAttempt {
  final RestoreKind kind;
  final PurchaseFailure? failure;

  const RestoreAttempt(this.kind, {this.failure});
}
