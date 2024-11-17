import 'package:departures/provider/theme_modes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  AppThemeMode _themeModeEnum = AppThemeMode.system;
  AppThemeMode get themeModeEnum => _themeModeEnum;

  bool get materialYou => _themeModeEnum == AppThemeMode.you;

  ThemeProvider() {
    loadThemePreference();
  }

  Future<void> saveThemePreference(AppThemeMode themeMode) async {
    _themeModeEnum = themeMode;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', _themeModeEnum.index);
  }

  Future<void> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeIndex = prefs.getInt('themeMode');

    if (themeIndex != null) {
      _themeModeEnum = AppThemeMode.values[themeIndex];
      notifyListeners();
    }
  }

  void setThemeMode(AppThemeMode mode) {
    saveThemePreference(mode);
  }
}
