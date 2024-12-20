import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSettingsProvider with ChangeNotifier {
  String _host = "";
  String get mainHost => _host;

  int _duration = 30;
  int get duration => _duration;

  ApiSettingsProvider() {
    loadHostPreferences();
    loadDuration();
  }

  Future<void> loadHostPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? host = prefs.getString("apiHost");

    if (host != null) {
      _host = host;
    }

    notifyListeners();
  }

  Future<void> loadDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? duration = prefs.getInt("duration");

    if (duration != null) {
      _duration = duration;
    } else {
      _duration = 30;
      saveDuration();
    }

    notifyListeners();
  }

  Future<void> saveHost(String mainHost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiHost', mainHost);
  }

  Future<void> saveDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('duration', _duration);
  }

  void setMainHost(String mainHost) {
    saveHost(mainHost);
  }

  void setDuration(int value) {
    _duration = value;
    notifyListeners();
    saveDuration();
  }
}
