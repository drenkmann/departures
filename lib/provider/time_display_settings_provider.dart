import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeDisplaySettingsProvider with ChangeNotifier {
  bool _showActualTime = true;
  bool get showActualTime => _showActualTime;

  TimeDisplaySettingsProvider() {
    loadTimeDisplayPreferences();
  }

  Future<void> loadTimeDisplayPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showActualTime = prefs.getBool("showActualTime");

    if (showActualTime != null) {
      _showActualTime = showActualTime;
    }

    notifyListeners();
  }

  Future<void> saveTimeDisplayPreference(bool showActualTime) async {
    _showActualTime = showActualTime;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showActualTime', showActualTime);
  }

  void setShowActualTime(bool showActualTime) {
    saveTimeDisplayPreference(showActualTime);
  }
}
