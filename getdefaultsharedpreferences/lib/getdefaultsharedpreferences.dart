
import 'getdefaultsharedpreferences_platform_interface.dart';

class Getdefaultsharedpreferences {
  Future<String?> getStringDefault(String key, {String returnValue = ""})
  {
    return GetdefaultsharedpreferencesPlatform.instance.getStringDefault(key, returnValue: returnValue);
  }

  Future<int?> getStringWithFileDefault(String file, String key, {int returnValue = 0})
  {
    return GetdefaultsharedpreferencesPlatform.instance.getStringWithFileDefault(file, key, returnValue: returnValue);
  }
}
