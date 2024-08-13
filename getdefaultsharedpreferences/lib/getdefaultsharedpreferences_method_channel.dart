import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'getdefaultsharedpreferences_platform_interface.dart';

/// An implementation of [GetdefaultsharedpreferencesPlatform] that uses method channels.
class MethodChannelGetdefaultsharedpreferences extends GetdefaultsharedpreferencesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('getdefaultsharedpreferences');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getStringDefault(String key, {String returnValue = ""}) async {
    final version = await methodChannel.invokeMethod<String>('getStringDefault', {"key":key, "returnValue": returnValue});
    return version;
  }

  @override
  Future<int?> getStringWithFileDefault(String file, String key, {int returnValue = 0}) async {
    final version = await methodChannel.invokeMethod<int>('getStringWithFileDefault', {"file": file, "key":key, "returnValue": returnValue});
    return version;
  }
}
