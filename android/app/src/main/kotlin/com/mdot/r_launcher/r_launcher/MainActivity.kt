package com.mdot.r_launcher.r_launcher

import AppsChangeBroadcastReceiver
import AppsChangeListener
import android.app.WallpaperManager
import android.content.*
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.drawable.Drawable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel;
import android.os.Bundle
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.util.Log
import android.widget.Toast
import io.flutter.plugin.common.EventChannel
import java.io.ByteArrayOutputStream
import kotlinx.coroutines.*
import spencerstudios.com.bungeelib.Bungee


class MainActivity: FlutterActivity() {
    private val scope = CoroutineScope(Job() + Dispatchers.Main)
    private val PLATFORM_CHANNEL: String = "com.mdot.r_launcher/channels"
    private val APP_EVENTS: String = "com.mdot.r_launcher/events/apps"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val eventChannel = EventChannel(flutterEngine?.dartExecutor?.binaryMessenger,APP_EVENTS)
        eventChannel.setStreamHandler(
                object: EventChannel.StreamHandler {
                    val receiver = AppsChangeBroadcastReceiver()
                    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink) {
                        receiver.setListener(object : AppsChangeListener() {
                            override fun onAppChange(info: String, packageName: String) {
                                Log.i("appchange", "App was $info. $packageName")
                                eventSink.success("$info/$packageName")
                            }

                        })
                        try {
                            val filter = IntentFilter()
                            filter.addAction(Intent.ACTION_PACKAGE_ADDED)
                            filter.addAction(Intent.ACTION_PACKAGE_REMOVED)
                            context.registerReceiver(receiver, filter)
                        } catch (e: Error){
                            Log.e("Intent ", "IE")
                        }
                    }

                    override fun onCancel(arguments: Any?) {
                      Log.i("Cancelled", "The op was cancelled.")
                       try{
                           context.unregisterReceiver(receiver)
                       } catch (e: Error){
                           Log.i("ErrorSt", "Some error")
                       }
                    }
                }
        )
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, PLATFORM_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission"-> {
                    val isDefault: String = isMyAppLauncherDefault(this)
                    Log.i("Permission", isDefault + "here")
                    result.success(isDefault)
                }
                "permission" -> {
                       val done =  resetPreferredLauncherAndOpenChooser(this)
                    result.success(done)
                }
                "wallpaper" -> {
                    val wallpaperManager: WallpaperManager= WallpaperManager.getInstance(this);
                    val wallpaperDrawable: Drawable = wallpaperManager.drawable;

                    val stream = ByteArrayOutputStream()
                    scope.launch(Dispatchers.Default) {
                        val wallPaperBitmap : Bitmap? = drawableToBitmap(wallpaperDrawable)
                       wallPaperBitmap?.compress(Bitmap.CompressFormat.PNG, 100, stream)

                        withContext(Dispatchers.Main) {
                            val byteArray: ByteArray = stream.toByteArray()
                            result.success(byteArray)
                          wallPaperBitmap?.recycle()
                        }
                    }
                }
                "apps" -> {
                    val name: String = call.argument("name")?: ""
                    val animationType: String = call.argument("animationType")?:""
                    val pm: PackageManager = this.packageManager
                    val launchIntent: Intent? = pm.getLaunchIntentForPackage(name)
                    if (launchIntent != null) {
                        this.startActivity(launchIntent)
                        when (animationType) {
                            "zoom" -> Bungee.zoom(this)
                            "split" -> Bungee.split(this)
                            "inAndOut" -> Bungee.inAndOut(this)
                            "swipeLeft" -> Bungee.swipeLeft(this)
                            "swipeRight"-> Bungee.swipeRight(this)
                            "fade" -> Bungee.fade(this)
                            "slideUp" -> Bungee.slideUp(this)
                            "spin" -> Bungee.spin(this)
                            else -> {
                               Bungee.shrink(this)
                            }

                        }


                    } else {
                        Toast.makeText(this, "App not found", Toast.LENGTH_SHORT).show();
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }


    private fun drawableToBitmap(drawable: Drawable): Bitmap? {
        var bitmap: Bitmap? = null
        if (drawable is BitmapDrawable) {
            val bitmapDrawable = drawable
            if (bitmapDrawable.bitmap != null) {
                return bitmapDrawable.bitmap
            }
        }
        bitmap = if (drawable.intrinsicWidth <= 0 || drawable.intrinsicHeight <= 0) {
            Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
        } else {
            Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        }
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight())
        drawable.draw(canvas)
        return bitmap
    }

    private fun isMyAppLauncherDefault(context: Context): String {
        val intent = Intent(Intent.ACTION_MAIN)
        intent.addCategory(Intent.CATEGORY_HOME)
        val resolveInfo: ResolveInfo? = packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
        val currentHomePackage: String? = resolveInfo?.activityInfo?.packageName
        return if(context.packageName == currentHomePackage){
            "true"
        } else {
            "false"
        }

    }
    private fun resetPreferredLauncherAndOpenChooser(context: Context):Boolean {
//        val resolveInfo: ResolveInfo? = packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
//        val currentHomePackage: String = resolveInfo!!.activityInfo.packageName
        val selector = Intent(Intent.ACTION_MAIN)
        selector.addCategory(Intent.CATEGORY_HOME)
        selector.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(selector)
        return  true
    }
}

