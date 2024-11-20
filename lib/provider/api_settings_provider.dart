import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSettingsProvider with ChangeNotifier {
  String _mainHost = "";
  String get mainHost => _mainHost;

  ApiSettingsProvider() {
    loadHostPreferences();
  }

  Future<void> loadHostPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mainHost = prefs.getString("apiHost");

    if (mainHost != null) {
      _mainHost = mainHost;
    }

    notifyListeners();
  }

  Future<void> saveHostPreference(String mainHost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiHost', mainHost);
  }

  void setMainHost(String mainHost) {
    saveHostPreference(mainHost);
  }
}
