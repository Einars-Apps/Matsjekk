package com.example.mat_sjekk

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** Play flavor has no HMS client and must not answer a Huawei purchase. */
class HmsIapBridge(private val activity: Activity) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "flavor") {
            result.success("play")
            return
        }
        result.success(
            mapOf(
                "status" to "notConfigured",
                "message" to "HMS IAP is only built into the huawei flavor.",
                "missing" to listOf("huawei flavor"),
            ),
        )
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean = false
}
