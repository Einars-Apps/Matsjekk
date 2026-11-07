import 'package:flutter/services.dart';

import 'huawei_iap_api.dart';

/// Method channel for the HMS IAP SDK used only by the huawei Android flavor.
/// Official calls: isEnvReady, obtainProductInfo, createPurchaseIntent,
/// obtainOwnedPurchases. priceType 1 is the non-consumable.
/// https://developer.huawei.com/consumer/en/doc/HMS-Plugin-Guides-V1/introduction-0000001051001685-V1
class HuaweiChannelApi implements HuaweiIapApi {
  HuaweiChannelApi({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.ebors.matsjekk/hms_iap');

  final MethodChannel _channel;

  Future<String?> storeFlavor() async {
    try {
      return await _channel.invokeMethod<String>('flavor');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<HuaweiIapResponse> query(String productId) {
    return _invoke('query', productId);
  }

  @override
  Future<HuaweiIapResponse> buy(String productId) {
    return _invoke('buy', productId);
  }

  @override
  Future<HuaweiIapResponse> restore() {
    return _invoke('restore', null);
  }

  Future<HuaweiIapResponse> _invoke(String method, String? productId) async {
    try {
      final raw = await _channel.invokeMapMethod<Object?, Object?>(
        method,
        productId == null ? null : {'productId': productId},
      );
      if (raw == null) {
        return const HuaweiIapResponse(
          status: 'error',
          message: 'HMS IAP returned an empty response.',
        );
      }
      return HuaweiIapResponse.fromMap(raw);
    } on MissingPluginException {
      return const HuaweiIapResponse(
        status: 'notConfigured',
        message: 'HMS IAP channel is absent. Build the huawei flavor.',
        missing: ['huawei flavor'],
      );
    } on PlatformException catch (error) {
      return HuaweiIapResponse(
        status: 'error',
        message: error.message ?? error.code,
      );
    }
  }
}
