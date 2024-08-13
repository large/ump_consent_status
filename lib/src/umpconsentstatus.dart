import 'dart:ffi';
import 'dart:io';

import 'package:getdefaultsharedpreferences/getdefaultsharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ump_consent_status/model/consentstatus.dart';

import '../model/adconfig.dart';

/// Class for handling
class UmpConsentStatus {
  SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  /// Returns the status of what consent user has approved
  Future<AdConfig> consentStatus(String goodVendors) async {
    //Default as none
    AdConfig res = AdConfig.none;

    // default string for "no consent", used in cases where no configuration has previously been stored
    String defaultPurposeString = "0000000000";

    // relevant strings are those for purpose consent or legitimate interest, as well as vendors
    String tcConsentString =
        await asyncPrefs.getString("IABTCF_PurposeConsents") ??
            defaultPurposeString;
    String tcInterestString =
        await asyncPrefs.getString("IABTCF_PurposeLegitimateInterests") ??
            defaultPurposeString;
    String tcVendorString =
        await asyncPrefs.getString("IABTCF_VendorConsents") ?? "0";

    /// SharedPreferences for Android is "locked" into a spesific xml-file
    /// I have asked a question regarding this to the flutter-team:
    /// https://github.com/flutter/flutter/issues/153300
    /// Meanwhile my android "hack" plugin needs to be used
    if (Platform.isAndroid) {
      Getdefaultsharedpreferences androidSharedPrefs =
          Getdefaultsharedpreferences();
      tcConsentString = await androidSharedPrefs.getStringDefault(
              "IABTCF_PurposeConsents",
              returnValue: defaultPurposeString) ??
          defaultPurposeString;
      tcInterestString = await androidSharedPrefs.getStringDefault(
              "IABTCF_PurposeLegitimateInterests",
              returnValue: defaultPurposeString) ??
          defaultPurposeString;
      tcVendorString = await androidSharedPrefs.getStringDefault(
              "IABTCF_VendorConsents",
              returnValue: defaultPurposeString) ??
          defaultPurposeString;
    }

    // we need consent for the following purposes N, stored in positions N-1 of the consent string:
    //   1, 3 and 4 to show all ads
    //   1 to show non-personalized ads
    //   no consent to show limited ads
    if (bitStringTrue(tcConsentString, 0) &&
        bitStringTrue(tcConsentString, 2) &&
        bitStringTrue(tcConsentString, 3)) {
      res = AdConfig.all;
    } else if (bitStringTrue(tcConsentString, 0)) {
      res = AdConfig.nonPersonalized;
    }

    // in any case we need at least legitimate interest for purposes N = 2, 7, 9 and 10,
    // stored in positions N-1 of either purpose string:
    bool sufficientInterest = ((bitStringTrue(tcConsentString, 1) ||
            bitStringTrue(tcInterestString, 1)) &&
        (bitStringTrue(tcConsentString, 6) ||
            bitStringTrue(tcInterestString, 6)) &&
        (bitStringTrue(tcConsentString, 8) ||
            bitStringTrue(tcInterestString, 8)) &&
        (bitStringTrue(tcConsentString, 9) ||
            bitStringTrue(tcInterestString, 9)));

    if (!sufficientInterest) {
      return AdConfig.none;
    }

    // if the stored string is shorter than what is necessary, at least some vendors will not be
    // configured properly.
    if (tcVendorString.length < goodVendors.length) {
      return AdConfig.unclear;
    }

    // build a regex that must match all '1' but not the '0' characters in goodVendorConfiguration,
    // and allows this configuration to be shorter than the string it is compared with
    var vendorRegex = RegExp("${goodVendors.replaceAll("0", ".")}.*");

    //if the regex matches, at least some ads should be served; if not, vendor string is unclear
    if (vendorRegex.hasMatch(tcVendorString)) {
      return res;
    } else {
      return AdConfig.unclear;
    }
  }

  //Helper that return if bit is 1 on given index
  bool bitStringTrue(String bitString, int index) {
    if (bitString.length <= index) return false;
    return bitString[index] == "1";
  }

  /// Returns the previous consent status (has user given consent)
  Future<ConsentStatus> getPreviousConsentStatus() async {
    //iOS (and probably macOS) has this variable as ump_status
    int consentStatus = await asyncPrefs.getInt("ump_status") ?? 0;

    /// SharedPreferences for Android is "locked" into a spesific xml-file
    /// I have asked a question regarding this to the flutter-team:
    /// https://github.com/flutter/flutter/issues/153300
    /// Meanwhile my android "hack" plugin needs to be used
    //In Android the file is called __GOOGLE_FUNDING_CHOICE_SDK_INTERNAL__.xml
    //Therefore we need to force reading from there, and it is called "consent_status"
    if (Platform.isAndroid) {
      Getdefaultsharedpreferences androidSharedPrefs =
      Getdefaultsharedpreferences();
      consentStatus = await androidSharedPrefs.getStringWithFileDefault(
          "__GOOGLE_FUNDING_CHOICE_SDK_INTERNAL__", "consent_status", returnValue: 0) ??
          0;
    }

    switch (consentStatus) {
      case 1:
        return ConsentStatus.unknown;
      case 2:
        return ConsentStatus.notRequired;
      case 3:
        return ConsentStatus.obtained;
      default:
        return ConsentStatus.unknown;
    }
  }

  /// Returns number of days since the consent was given
  /// Needs to be refreshed each 365 days (yearly)
  Future<int> daysSinceConsent()
  async {
    String tcString =
        await asyncPrefs.getString("IABTCF_TCString") ?? "";

    /// SharedPreferences for Android is "locked" into a spesific xml-file
    /// I have asked a question regarding this to the flutter-team:
    /// https://github.com/flutter/flutter/issues/153300
    /// Meanwhile my android "hack" plugin needs to be used
    if (Platform.isAndroid) {
      Getdefaultsharedpreferences androidSharedPrefs =
      Getdefaultsharedpreferences();
      tcString = await androidSharedPrefs.getStringDefault(
          "IABTCF_TCString",
          returnValue: "") ??
          "";
      }

    //TCString was not found, return invalid number of days
    if(tcString.isEmpty) return -1;

    // base64 alphabet used to store data in IABTCF string
    String base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

    // date is stored in digits 1..7 of the IABTCF string
    String dateSubstring = tcString.substring(1,7);

    // interpret date substring as base64-encoded integer value
    int timestamp = 0;
    dateSubstring.split("").forEach((c)
    {
      int value = base64.indexOf(c);
      timestamp = timestamp * 64 + value;
    });

    // timestamp is given is deci-seconds, convert to milliseconds
    timestamp *= 100;

    // compare with current timestamp to get age in days
    double daysAgo = (DateTime.now().millisecondsSinceEpoch - timestamp) / (1000*60*60*24);
    return daysAgo.toInt();
  }
}
