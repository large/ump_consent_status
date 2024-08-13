import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'getdefaultsharedpreferences_method_channel.dart';

abstract class GetdefaultsharedpreferencesPlatform extends PlatformInterface {
  /// Constructs a GetdefaultsharedpreferencesPlatform.
  GetdefaultsharedpreferencesPlatform() : super(token: _token);

  static final Object _token = Object();

  static GetdefaultsharedpreferencesPlatform _instance = MethodChannelGetdefaultsharedpreferences();

  /// The default instance of [GetdefaultsharedpreferencesPlatform] to use.
  ///
  /// Defaults to [MethodChannelGetdefaultsharedpreferences].
  static GetdefaultsharedpreferencesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GetdefaultsharedpreferencesPlatform] when
  /// they register themselves.
  static set instance(GetdefaultsharedpreferencesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getStringDefault(String key, {String returnValue = ""}) {
    throw UnimplementedError('getStringDefault() has not been implemented.');
  }

  Future<int?> getStringWithFileDefault(String file, String key, {int returnValue = 0}) {
    throw UnimplementedError('getStringWithFileDefault() has not been implemented.');
  }
}
