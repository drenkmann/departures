import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSettingsProvider with ChangeNotifier {
  String _host = "";
  String get mainHost => _host;

  ApiSettingsProvider() {
    loadHostPreferences();
  }

  Future<void> loadHostPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? host = prefs.getString("apiHost");

    if (host != null) {
      _host = host;
    }

    notifyListeners();
  }

  Future<void> saveHost(String mainHost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiHost', mainHost);
  }

  void setMainHost(String mainHost) {
    saveHost(mainHost);
  }
}
