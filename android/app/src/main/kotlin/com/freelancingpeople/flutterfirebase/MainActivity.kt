package com.freelancingpeople.flutterfirebase

import android.os.Bundle
import android.view.ViewTreeObserver
import android.view.WindowManager

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val initialColor = window.statusBarColor
    window.statusBarColor = 0x00000000

    GeneratedPluginRegistrant.registerWith(this)

    val layoutListener = object : ViewTreeObserver.OnGlobalLayoutListener {
      override fun onGlobalLayout() {
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
        window.statusBarColor = initialColor
        flutterView.viewTreeObserver.removeOnGlobalLayoutListener(this)
      }
    }
    flutterView.viewTreeObserver.addOnGlobalLayoutListener(layoutListener)
  }
}
