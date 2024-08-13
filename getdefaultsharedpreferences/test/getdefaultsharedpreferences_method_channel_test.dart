import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getdefaultsharedpreferences/getdefaultsharedpreferences_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGetdefaultsharedpreferences platform = MethodChannelGetdefaultsharedpreferences();
  const MethodChannel channel = MethodChannel('getdefaultsharedpreferences');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
