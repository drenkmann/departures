import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHostProvider with ChangeNotifier {
  String _mainHost = "";
  String get mainHost => _mainHost;

  String _fallbackHost = "";
  String get fallbackHost => _fallbackHost;

  ApiHostProvider() {
    loadHostPreferences();
  }

  Future<void> loadHostPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mainHost = prefs.containsKey("apiHost") ? prefs.getString("apiHost") : null;
    String? fallbackHost = prefs.containsKey("apiFallbackHost") ? prefs.getString("apiFallbackHost") : null;

    if (mainHost != null) {
      _mainHost = mainHost;
    }

    if (fallbackHost != null) {
      _fallbackHost = fallbackHost;
    }

    notifyListeners();
  }

  Future<void> saveMainHostPreference(String mainHost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiHost', mainHost);
  }

  void setMainHost(String mainHost) {
    saveMainHostPreference(mainHost);
  }

  Future<void> saveFallbackHostPreferences(String fallbackHost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiFallbackHost', fallbackHost);
  }

  void setFallbackHost(String fallbackHost) {
    saveFallbackHostPreferences(fallbackHost);
  }
}
