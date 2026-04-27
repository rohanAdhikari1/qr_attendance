package com.rohan.qr_attendance

import android.os.Bundle
import android.view.WindowManager
import android.app.ActivityManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){
    private val KIOSK_CHANNEL = "com.rohan.qr_attendance/kiosk"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        startLockTask()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, KIOSK_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startKiosk" -> {
                        startLockTask()
                        result.success(null)
                    }
                    "stopKiosk" -> {
                        stopLockTask()
                        result.success(null)
                    }
                    "isKioskActive" -> {
                        // lockTaskModeState > 0 means active (Android 5.0+)
                        val active = android.os.Build.VERSION.SDK_INT >= 21 &&
                                (getSystemService(android.app.ActivityManager::class.java)
                                    .lockTaskModeState > 0)
                        result.success(active)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
    }
}
