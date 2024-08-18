import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static const _APP_PREF = "APP_PREF";
  static const _USER_PREF = "USER_PREF";

  static const _PLAYER_TOKEN            = "playerToken";
  static const _PLAYER_ID               = "playerId";
  static const _REGISTRATION_RESPONSE   = "registrationResponse";
  static const _CASH_BALANCE            = "cashBalance";
  static const _TOTAL_BALANCE           = "totalBalance";
  static const _UNREAD_MSG_COUNT        = "unreadMessageCount";
  static const _DEEPLINK_DATA           = "deeplinkData";

  static final SharedPrefUtils _instance = SharedPrefUtils._ctor();

  factory SharedPrefUtils() {
    return _instance;
  }

  SharedPrefUtils._ctor();

  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // APP_DATA functions

  static bool getAppFirstTimeLaunch() {
    return _prefs.getBool('first_time') ?? true;
  }

  static setAppFirstTimeLaunch() {
    _prefs.setBool('first_time', false);
  }


  static setAppStringValue(String key, String value) {
    final String? storedData =
    _prefs.containsKey(_APP_PREF) ? _prefs.getString(_APP_PREF)! : null;
    Map newData = {key: value};
    Map newDataMap = {};

    if (storedData != null) {
      newDataMap.addAll(jsonDecode(storedData));
      newDataMap.addAll(newData);
    } else {
      newDataMap = newData;
    }

    _prefs.setString(_APP_PREF, jsonEncode(newDataMap));
  }

  static setUserStringValue(String key, String value) {
    final String? storedData =
    _prefs.containsKey(_USER_PREF) ? _prefs.getString(_USER_PREF) : null;
    Map newData = {key: value};
    Map newDataMap = {};

    if (storedData != null) {
      newDataMap.addAll(jsonDecode(storedData));
      newDataMap.addAll(newData);
    } else {
      newDataMap = newData;
    }

    _prefs.setString(_USER_PREF, jsonEncode(newDataMap));
  }

  static String getAppStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(_APP_PREF) != null
        ? jsonDecode(_prefs.getString(_APP_PREF) ?? '')
        : {};

    return allPrefs[key] ?? "";
  }

  static String getStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(_USER_PREF) != null
        ? jsonDecode(_prefs.getString(_USER_PREF) ?? '')
        : {};
    return allPrefs[key] ?? '';
  }

  static String getUserStringValue(String key) {
    Map<String, dynamic> allPrefs = _prefs.getString(_USER_PREF) != null
        ? jsonDecode(_prefs.getString(_USER_PREF) ?? '')
        : {};
    return allPrefs[key] ?? '';
  }

  static Map<String, dynamic> getAllUserPrefs() {
    Map<String, dynamic> allPrefs = _prefs.containsKey(_USER_PREF)
        ? jsonDecode(_prefs.getString(_USER_PREF)!)
        : {};
    return allPrefs;
  }

  static Map<String, dynamic> getAllAppPrefs() {
    Map<String, dynamic> allPrefs = _prefs.containsKey(_APP_PREF)
        ? jsonDecode(_prefs.getString(_APP_PREF)!)
        : {};
    return allPrefs;
  }

  static removeValue(String key) {
    return _prefs.remove(key);
  }

  ////////////////////////////// SETTERS  /////////////////////////////////////////

  static set playerToken(String value)          => setUserStringValue(_PLAYER_TOKEN, value);

  static set playerId(String value)             => setUserStringValue(_PLAYER_ID, value);

  static set registrationResponse(String value) => setUserStringValue(_REGISTRATION_RESPONSE, value);

  static set deeplinkResponse(String value)     => setUserStringValue(_DEEPLINK_DATA, value);

  static set cashBalance(String value)          => setUserStringValue(_CASH_BALANCE, value);

  static set totalBalance(String value)         => setUserStringValue(_TOTAL_BALANCE, value);

  static set unreadMsgCount(String value)       => setUserStringValue(_UNREAD_MSG_COUNT, value);


  /////////////////////////// GETTERS //////////////////////////////

  static String get playerToken           => getStringValue(_PLAYER_TOKEN);

  static String get playerId              => getStringValue(_PLAYER_ID);

  static String get registrationResponse  => getUserStringValue(_REGISTRATION_RESPONSE);

  static String get deeplinkResponse      => getUserStringValue(_DEEPLINK_DATA);

  static String get cashBalance           => getUserStringValue(_CASH_BALANCE);

  static String get totalBalance          => getUserStringValue(_TOTAL_BALANCE);

  static String get unreadMsgCount        => getUserStringValue(_UNREAD_MSG_COUNT);

}

enum PrefType { APP_PREF, USER_PREF }

extension PrefExtension on PrefType {
  String get value {
    switch (this) {
      case PrefType.APP_PREF:
        return SharedPrefUtils._APP_PREF;
      case PrefType.USER_PREF:
        return SharedPrefUtils._USER_PREF;
    }
  }
}
