// import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData {
  // === members
  SharedPreferences? prefs;
  String? token;
  // String username;
  bool loaded = false;

  // === internals
  static final GlobalData _singleton = GlobalData._internal();

  factory GlobalData() {
    return _singleton;
  }

  GlobalData._internal();

  Future<void> loadSharedPreferences() async {
    _singleton.prefs = await SharedPreferences.getInstance();
    _singleton.token = _singleton.prefs!.getString('token') ?? null;
    _singleton.loaded = true;
  }

  void test() {
    print(
        "GlobalData: _prefs=${_singleton.prefs} loaded=[${_singleton.loaded}]");
  }

  /// universal getter
  /// @return null if not found
  dynamic get(String key) {
    return _singleton.prefs!.get(key);
  }

  // universal setter
  void set(String key, dynamic value) {
    if (value is String) {
      _singleton.prefs!.setString(key, value);
      print("GlobalData: '$key' set to '$value'");
      return;
    }
    if (value is int) {
      _singleton.prefs!.setInt(key, value);
      print("GlobalData: '$key' set to $value (int)");
      return;
    }
    if (value is bool) {
      _singleton.prefs!.setBool(key, value);
      print("GlobalData: '$key' set to $value (bool)");
      return;
    }

    print("set[$key]: not handled -> " + (value).toString());
  }

  // universal getter
  bool has(String key) {
    return (_singleton.prefs != null) && _singleton.prefs!.containsKey(key);
  }

  void remove(String key) {
    _singleton.prefs!.remove(key);
  }

  void dump() {
    //_singleton.prefs.for
  }

  // [deprecated] TODO:
  void setToken(String token) {
    _singleton.prefs!.setString('token', token);
  }

  void clear() {
    _singleton.prefs!.clear();
  }
}
