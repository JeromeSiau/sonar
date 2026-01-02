package com.sonar.bluetoothFinder

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import java.text.SimpleDateFormat
import java.util.*

class SonarWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.sonar_widget)

            val deviceCount = widgetData.getInt("device_count", 0)
            val devicesJson = widgetData.getString("devices_json", "[]") ?: "[]"

            views.setTextViewText(R.id.device_count, deviceCount.toString())

            val devices = parseDevicesJson(devicesJson)

            if (devices.isEmpty()) {
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
                views.setViewVisibility(R.id.device_row_1, View.GONE)
                views.setViewVisibility(R.id.device_row_2, View.GONE)
                views.setViewVisibility(R.id.device_row_3, View.GONE)
                
                val scannerPendingIntent = createDevicePendingIntent(context, appWidgetId, 0, null)
                views.setOnClickPendingIntent(R.id.widget_container, scannerPendingIntent)
            } else {
                views.setViewVisibility(R.id.empty_state, View.GONE)

                if (devices.size >= 1) {
                    views.setViewVisibility(R.id.device_row_1, View.VISIBLE)
                    views.setTextViewText(R.id.device_name_1, devices[0].name)
                    views.setTextViewText(R.id.device_time_1, devices[0].lastSeenText)
                    views.setOnClickPendingIntent(R.id.device_row_1, 
                        createDevicePendingIntent(context, appWidgetId, 1, devices[0].id))
                } else {
                    views.setViewVisibility(R.id.device_row_1, View.GONE)
                }

                if (devices.size >= 2) {
                    views.setViewVisibility(R.id.device_row_2, View.VISIBLE)
                    views.setTextViewText(R.id.device_name_2, devices[1].name)
                    views.setTextViewText(R.id.device_time_2, devices[1].lastSeenText)
                    views.setOnClickPendingIntent(R.id.device_row_2,
                        createDevicePendingIntent(context, appWidgetId, 2, devices[1].id))
                } else {
                    views.setViewVisibility(R.id.device_row_2, View.GONE)
                }

                if (devices.size >= 3) {
                    views.setViewVisibility(R.id.device_row_3, View.VISIBLE)
                    views.setTextViewText(R.id.device_name_3, devices[2].name)
                    views.setTextViewText(R.id.device_time_3, devices[2].lastSeenText)
                    views.setOnClickPendingIntent(R.id.device_row_3,
                        createDevicePendingIntent(context, appWidgetId, 3, devices[2].id))
                } else {
                    views.setViewVisibility(R.id.device_row_3, View.GONE)
                }
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun createDeviceUri(deviceId: String?): Uri {
            return if (deviceId != null) {
                Uri.parse("sonar://radar/${Uri.encode(deviceId)}?homeWidget")
            } else {
                Uri.parse("sonar://scanner?homeWidget")
            }
        }

        private fun createDevicePendingIntent(
            context: Context,
            appWidgetId: Int,
            rowIndex: Int,
            deviceId: String?
        ): PendingIntent {
            val uri = createDeviceUri(deviceId)
            return HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, uri)
        }

        private fun parseDevicesJson(json: String): List<DeviceInfo> {
            val devices = mutableListOf<DeviceInfo>()
            try {
                val jsonArray = JSONArray(json)
                for (i in 0 until jsonArray.length()) {
                    val obj = jsonArray.getJSONObject(i)
                    val name = obj.optString("name", "Unknown")
                    val id = obj.optString("id", "")
                    val lastSeenAt = obj.optString("lastSeenAt", "")
                    val lastSeenText = formatTimeAgo(lastSeenAt)
                    devices.add(DeviceInfo(id, name, lastSeenText))
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return devices
        }

        private fun formatTimeAgo(isoDateString: String): String {
            if (isoDateString.isEmpty()) return "—"
            return try {
                val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
                formatter.timeZone = TimeZone.getTimeZone("UTC")
                val date = formatter.parse(isoDateString) ?: return "—"
                val now = Date()
                val diffMs = now.time - date.time
                val diffMinutes = diffMs / (1000 * 60)
                val diffHours = diffMs / (1000 * 60 * 60)
                val diffDays = diffMs / (1000 * 60 * 60 * 24)

                when {
                    diffMinutes < 1 -> "now"
                    diffMinutes < 60 -> "${diffMinutes}m"
                    diffHours < 24 -> "${diffHours}h"
                    else -> "${diffDays}d"
                }
            } catch (e: Exception) {
                "—"
            }
        }
    }

    data class DeviceInfo(val id: String, val name: String, val lastSeenText: String)
}
