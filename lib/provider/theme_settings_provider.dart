import 'package:departures/enums/app_theme_modes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  AppThemeMode _appThemeMode = AppThemeMode.system;
  AppThemeMode get appThemeMode => _appThemeMode;

  bool get materialYou => _appThemeMode == AppThemeMode.you;

  ThemeProvider() {
    loadThemePreference();
  }

  Future<void> saveThemePreference(AppThemeMode themeMode) async {
    _appThemeMode = themeMode;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _appThemeMode.index);
  }

  Future<void> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeIndex = prefs.getInt('themeMode');

    if (themeIndex != null) {
      _appThemeMode = AppThemeMode.values[themeIndex];
      notifyListeners();
    }
  }

  void setThemeMode(AppThemeMode mode) {
    saveThemePreference(mode);
  }
}
