class HuaweiIapResponse {
  final String status;
  final String? message;
  final String? signedData;
  final String? signature;
  final List<String> missing;
  final List<HuaweiOwnedPurchase> owned;

  final String? title;
  final String? price;

  const HuaweiIapResponse({
    required this.status,
    this.message,
    this.signedData,
    this.signature,
    this.title,
    this.price,
    this.missing = const [],
    this.owned = const [],
  });

  factory HuaweiIapResponse.fromMap(Map<Object?, Object?> raw) {
    final ownedRaw = raw['owned'];
    final owned = <HuaweiOwnedPurchase>[];
    if (ownedRaw is List) {
      for (final item in ownedRaw) {
        if (item is Map) {
          owned.add(HuaweiOwnedPurchase(
            signedData: item['signedData']?.toString() ?? '',
            signature: item['signature']?.toString() ?? '',
          ));
        }
      }
    }
    final missingRaw = raw['missing'];
    return HuaweiIapResponse(
      status: raw['status']?.toString() ?? 'error',
      message: raw['message']?.toString(),
      signedData: raw['signedData']?.toString(),
      signature: raw['signature']?.toString(),
      title: raw['title']?.toString(),
      price: raw['price']?.toString(),
      missing: missingRaw is List
          ? missingRaw.map((item) => item.toString()).toList()
          : const [],
      owned: owned,
    );
  }
}

class HuaweiOwnedPurchase {
  final String signedData;
  final String signature;

  const HuaweiOwnedPurchase({
    required this.signedData,
    required this.signature,
  });
}

abstract class HuaweiIapApi {
  Future<HuaweiIapResponse> query(String productId);
  Future<HuaweiIapResponse> buy(String productId);
  Future<HuaweiIapResponse> restore();
}
