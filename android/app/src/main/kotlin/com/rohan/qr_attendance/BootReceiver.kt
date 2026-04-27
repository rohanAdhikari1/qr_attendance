package com.rohan.qr_attendance

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Restarts the attendance app automatically after device reboot.
 * Critical for Nepal where power cuts are common — the kiosk
 * comes back online without any manual intervention.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {

            val launchIntent = Intent(context, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            }
            context.startActivity(launchIntent)
        }
    }
}
