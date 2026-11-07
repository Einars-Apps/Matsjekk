package com.example.mat_sjekk

import android.app.Activity
import android.content.Intent
import com.huawei.hms.iap.Iap
import com.huawei.hms.iap.IapClient
import com.huawei.hms.iap.entity.OrderStatusCode
import com.huawei.hms.iap.entity.OwnedPurchasesReq
import com.huawei.hms.iap.entity.ProductInfoReq
import com.huawei.hms.iap.entity.PurchaseIntentReq
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * HMS Core IAP for the non-consumable matsjekk_remove_ads_lifetime.
 * IapClient.PriceType.IN_APP_NONCONSUMABLE is the non-consumable price type.
 * Do not set signatureAlgorithm; the default client signature is SHA256withRSA.
 * https://developer.huawei.com/consumer/en/doc/HMSCore-Guides/dev-guide-0000001050132814
 */
class HmsIapBridge(private val activity: Activity) : MethodChannel.MethodCallHandler {
    private var pendingPurchase: MethodChannel.Result? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "flavor") {
            result.success("huawei")
            return
        }
        if (BuildConfig.HUAWEI_APP_ID.isBlank()) {
            result.success(
                mapOf(
                    "status" to "notConfigured",
                    "message" to "android/huawei.properties appId is empty.",
                    "missing" to listOf("android/huawei.properties appId"),
                ),
            )
            return
        }
        when (call.method) {
            "query" -> query(call.argument<String>("productId") ?: "", result)
            "buy" -> buy(call.argument<String>("productId") ?: "", result)
            "restore" -> restore(result)
            else -> result.notImplemented()
        }
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != purchaseRequest) return false
        val pending = pendingPurchase
        pendingPurchase = null
        if (pending == null) return true
        if (data == null) {
            pending.success(mapOf("status" to "cancelled", "message" to "No purchase result."))
            return true
        }
        val parsed = Iap.getIapClient(activity).parsePurchaseResultInfoFromIntent(data)
        when (parsed.returnCode) {
            OrderStatusCode.ORDER_STATE_SUCCESS -> {
                pending.success(
                    mapOf(
                        "status" to "ok",
                        "signedData" to parsed.inAppPurchaseData,
                        "signature" to parsed.inAppDataSignature,
                    ),
                )
            }
            OrderStatusCode.ORDER_STATE_CANCEL -> {
                pending.success(mapOf("status" to "cancelled"))
            }
            else -> {
                pending.success(
                    mapOf(
                        "status" to "error",
                        "message" to "Huawei purchase returnCode ${parsed.returnCode}",
                    ),
                )
            }
        }
        return true
    }

    private fun query(productId: String, result: MethodChannel.Result) {
        val client = Iap.getIapClient(activity)
        client.isEnvReady().addOnSuccessListener {
            val request = ProductInfoReq()
            request.priceType = IapClient.PriceType.IN_APP_NONCONSUMABLE
            request.productIds = listOf(productId)
            client.obtainProductInfo(request).addOnSuccessListener { info ->
                val product = info.productInfoList?.firstOrNull { it.productId == productId }
                if (product == null) {
                    result.success(mapOf("status" to "empty"))
                } else {
                    result.success(
                        mapOf(
                            "status" to "ok",
                            "title" to product.productName,
                            "price" to product.price,
                        ),
                    )
                }
            }.addOnFailureListener { error ->
                result.success(mapOf("status" to "error", "message" to (error.message ?: "obtainProductInfo failed")))
            }
        }.addOnFailureListener {
            result.success(
                mapOf(
                    "status" to "unavailable",
                    "message" to "HMS IAP isEnvReady failed. ${it.message ?: ""}".trim(),
                ),
            )
        }
    }

    private fun buy(productId: String, result: MethodChannel.Result) {
        val request = PurchaseIntentReq()
        request.priceType = IapClient.PriceType.IN_APP_NONCONSUMABLE
        request.productId = productId
        Iap.getIapClient(activity).createPurchaseIntent(request).addOnSuccessListener { intentResult ->
            val status = intentResult.status
            if (status != null && status.hasResolution()) {
                pendingPurchase = result
                status.startResolutionForResult(activity, purchaseRequest)
            } else {
                result.success(mapOf("status" to "error", "message" to (status?.statusMessage ?: "No purchase resolution")))
            }
        }.addOnFailureListener {
            result.success(mapOf("status" to "error", "message" to (it.message ?: "createPurchaseIntent failed")))
        }
    }

    private fun restore(result: MethodChannel.Result) {
        val client = Iap.getIapClient(activity)
        val rows = mutableListOf<Map<String, String>>()
        fun page(token: String?) {
            val request = OwnedPurchasesReq()
            request.priceType = IapClient.PriceType.IN_APP_NONCONSUMABLE
            if (!token.isNullOrEmpty()) request.continuationToken = token
            client.obtainOwnedPurchases(request).addOnSuccessListener { owned ->
                val data = owned.inAppPurchaseDataList ?: emptyList()
                val signatures = owned.inAppSignature ?: emptyList()
                data.forEachIndexed { index, signed ->
                    rows.add(
                        mapOf(
                            "signedData" to signed,
                            "signature" to signatures.getOrElse(index) { "" },
                        ),
                    )
                }
                val next = owned.continuationToken
                if (!next.isNullOrEmpty() && rows.size < 50) {
                    page(next)
                } else {
                    result.success(mapOf("status" to "ok", "owned" to rows))
                }
            }.addOnFailureListener {
                result.success(mapOf("status" to "error", "message" to (it.message ?: "obtainOwnedPurchases failed")))
            }
        }
        page(null)
    }

    private companion object {
        const val purchaseRequest = 9101
    }
}
