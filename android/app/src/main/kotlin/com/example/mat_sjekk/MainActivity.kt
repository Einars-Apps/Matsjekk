package com.example.mat_sjekk

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var hmsBridge: HmsIapBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val bridge = HmsIapBridge(this)
        hmsBridge = bridge
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.ebors.matsjekk/hms_iap")
            .setMethodCallHandler(bridge)
    }

    @Deprecated("Android contract")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (hmsBridge?.onActivityResult(requestCode, resultCode, data) == true) {
            return
        }
        super.onActivityResult(requestCode, resultCode, data)
    }
}
