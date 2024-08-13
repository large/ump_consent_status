import 'package:flutter/services.dart';

const platform = MethodChannel('sharedPrefsNative');

Future<void> callNativeMethod() async {
  try {
    await platform.invokeMethod('nativeMethod');
  } catch (e) {
    print('Error calling native method: $e');
  }
}