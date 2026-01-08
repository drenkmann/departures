import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DistanceSettingsProvider with ChangeNotifier {
  bool _showDistance = false;
  bool get showDistance => _showDistance;

  DistanceSettingsProvider() {
    loadDistancePreference();
  }

  Future<void> saveDistancePreference(bool show) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showDistance', _showDistance);
  }

  Future<void> loadDistancePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? show = prefs.getBool('showDistance');

    if (show != null) {
      _showDistance = show;
      notifyListeners();
    }
  }

  void setShowDistance(bool show) {
    _showDistance = show;
    notifyListeners();
    saveDistancePreference(show);
  }
}
