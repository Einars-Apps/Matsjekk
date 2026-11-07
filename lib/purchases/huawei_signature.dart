import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

import 'purchase_models.dart';

class HuaweiVerification {
  final bool valid;
  final PurchaseFailure? failure;
  final String? purchaseToken;

  const HuaweiVerification._(this.valid, this.failure, this.purchaseToken);

  const HuaweiVerification.valid(String token)
      : this._(true, null, token);

  const HuaweiVerification.failed(PurchaseFailure failure)
      : this._(false, failure, null);
}

/// Verifies a Huawei IAP payload with SHA256withRSA, the algorithm HMS uses
/// when the client does not request PSS.
/// https://developer.huawei.com/consumer/en/doc/HMSCore-Guides/verifying-signature-returned-result-0000001050033088
class HuaweiSignatureVerifier {
  final RSAPublicKey? publicKey;

  const HuaweiSignatureVerifier(this.publicKey);

  factory HuaweiSignatureVerifier.fromSpki(String? spkiOrPem) {
    if (spkiOrPem == null || spkiOrPem.trim().isEmpty) {
      return const HuaweiSignatureVerifier(null);
    }
    return HuaweiSignatureVerifier(rsaPublicKeyFromSpki(spkiOrPem));
  }

  HuaweiVerification verify({
    required String signedData,
    required String signatureBase64,
    required String expectedProductId,
  }) {
    final key = publicKey;
    if (key == null) {
      return const HuaweiVerification.failed(PurchaseFailure(
        PurchaseFailureKind.verificationNotConfigured,
        'Huawei purchase signature cannot be checked because HUAWEI_IAP_PUBLIC_KEY is not set.',
        missing: ['HUAWEI_IAP_PUBLIC_KEY'],
      ));
    }
    Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(signedData);
      if (decoded is! Map) {
        throw const FormatException('payload');
      }
      payload = Map<String, dynamic>.from(decoded);
    } catch (_) {
      return const HuaweiVerification.failed(PurchaseFailure(
        PurchaseFailureKind.verificationRejected,
        'Huawei purchase data is not valid JSON.',
      ));
    }
    final productId = payload['productId']?.toString() ?? '';
    if (productId != expectedProductId) {
      return HuaweiVerification.failed(PurchaseFailure(
        PurchaseFailureKind.productIdMismatch,
        'Huawei returned $productId, expected $expectedProductId.',
      ));
    }
    final state = payload['purchaseState'];
    final purchased = state == 0 || state == '0';
    if (!purchased) {
      return const HuaweiVerification.failed(PurchaseFailure(
        PurchaseFailureKind.verificationRejected,
        'Huawei purchaseState is not purchased.',
      ));
    }
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(false, PublicKeyParameter<RSAPublicKey>(key));
    Uint8List signature;
    try {
      signature = base64.decode(signatureBase64);
    } catch (_) {
      return const HuaweiVerification.failed(PurchaseFailure(
        PurchaseFailureKind.verificationRejected,
        'Huawei signature is not base64.',
      ));
    }
    final ok = signer.verifySignature(
      Uint8List.fromList(utf8.encode(signedData)),
      RSASignature(signature),
    );
    if (!ok) {
      return const HuaweiVerification.failed(PurchaseFailure(
        PurchaseFailureKind.verificationRejected,
        'Huawei purchase signature does not match the configured public key.',
      ));
    }
    return HuaweiVerification.valid(payload['purchaseToken']?.toString() ?? '');
  }
}

RSAPublicKey rsaPublicKeyFromSpki(String spkiOrPem) {
  final body = spkiOrPem
      .replaceAll('-----BEGIN PUBLIC KEY-----', '')
      .replaceAll('-----END PUBLIC KEY-----', '')
      .replaceAll(RegExp(r'\s+'), '');
  final bytes = base64.decode(body);
  final top = ASN1Parser(Uint8List.fromList(bytes)).nextObject() as ASN1Sequence;
  final bitString = top.elements![1] as ASN1BitString;
  final keyBytes = Uint8List.fromList(bitString.stringValues!);
  final pkcs1 = ASN1Parser(keyBytes).nextObject() as ASN1Sequence;
  final modulus = (pkcs1.elements![0] as ASN1Integer).integer!;
  final exponent = (pkcs1.elements![1] as ASN1Integer).integer!;
  return RSAPublicKey(modulus, exponent);
}

String spkiFromPublicKey(RSAPublicKey key) {
  final pkcs1 = ASN1Sequence(elements: [
    ASN1Integer(key.modulus),
    ASN1Integer(key.exponent),
  ]);
  final pkcs1Bytes = pkcs1.encode();
  final spki = ASN1Sequence(elements: [
    ASN1Sequence(elements: [
      ASN1ObjectIdentifier.fromIdentifierString('1.2.840.113549.1.1.1'),
      ASN1Null(),
    ]),
    ASN1BitString(stringValues: pkcs1Bytes),
  ]);
  return base64.encode(spki.encode());
}
