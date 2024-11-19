import 'package:flutter/material.dart';

enum AppThemeMode {
  system(ThemeMode.system),
  dark(ThemeMode.dark),
  light(ThemeMode.light),
  you(ThemeMode.system);

  const AppThemeMode(this.themeMode);
  final ThemeMode themeMode;
}
