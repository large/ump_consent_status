package com.getdefaultsharedpreferences.getdefaultsharedpreferences

import android.content.Context
import android.util.Log
import androidx.preference.PreferenceManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** GetdefaultsharedpreferencesPlugin */
class GetdefaultsharedpreferencesPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "getdefaultsharedpreferences")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    if( call.method == "getStringDefault") {
      val key = call.argument<String>("key")
      val returnValue = call.argument<String?>("returnValue")
      val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
      val res = sharedPreferences.getString(key, returnValue)
      result.success(res);
      return;
    }

    if( call.method == "getStringWithFileDefault") {
      val file = call.argument<String>("file")
      val key = call.argument<String>("key")
      val returnValue = call.argument<Int?>("returnValue") ?: 0
      val sharedPreferences = context.getSharedPreferences(file, Context.MODE_PRIVATE)
      val res = sharedPreferences.getInt(key, returnValue)
      result.success(res);
      return;
    }

    result.notImplemented()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
