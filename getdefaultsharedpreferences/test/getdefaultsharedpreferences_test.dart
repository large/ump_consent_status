import 'package:flutter_test/flutter_test.dart';
import 'package:getdefaultsharedpreferences/getdefaultsharedpreferences.dart';
import 'package:getdefaultsharedpreferences/getdefaultsharedpreferences_platform_interface.dart';
import 'package:getdefaultsharedpreferences/getdefaultsharedpreferences_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGetdefaultsharedpreferencesPlatform
    with MockPlatformInterfaceMixin
    implements GetdefaultsharedpreferencesPlatform {

  @override
  Future<String?> getStringDefault(String key, {String returnValue = ""}) {
    // TODO: implement getStringDefault
    throw UnimplementedError();
  }

  @override
  Future<int?> getStringWithFileDefault(String file, String key, {int returnValue = 0}) {
    // TODO: implement getStringWithFileDefault
    throw UnimplementedError();
  }
}

void main() {
  final GetdefaultsharedpreferencesPlatform initialPlatform = GetdefaultsharedpreferencesPlatform.instance;

  test('$MethodChannelGetdefaultsharedpreferences is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGetdefaultsharedpreferences>());
  });

  test('getPlatformVersion', () async {
    Getdefaultsharedpreferences getdefaultsharedpreferencesPlugin = Getdefaultsharedpreferences();
    MockGetdefaultsharedpreferencesPlatform fakePlatform = MockGetdefaultsharedpreferencesPlatform();
    GetdefaultsharedpreferencesPlatform.instance = fakePlatform;

    //expect(await getdefaultsharedpreferencesPlugin.getPlatformVersion(), '42');
  });
}
