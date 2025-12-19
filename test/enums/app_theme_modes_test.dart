import 'package:departures/enums/app_theme_modes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppThemeMode', () {
    test('should have correct themeMode for system', () {
      expect(AppThemeMode.system.themeMode, equals(ThemeMode.system));
    });

    test('should have correct themeMode for dark', () {
      expect(AppThemeMode.dark.themeMode, equals(ThemeMode.dark));
    });

    test('should have correct themeMode for light', () {
      expect(AppThemeMode.light.themeMode, equals(ThemeMode.light));
    });

    test('should have correct themeMode for you', () {
      expect(AppThemeMode.you.themeMode, equals(ThemeMode.system));
    });

    test('should have four values', () {
      expect(AppThemeMode.values.length, equals(4));
    });

    test('should contain all expected values', () {
      expect(AppThemeMode.values, contains(AppThemeMode.system));
      expect(AppThemeMode.values, contains(AppThemeMode.dark));
      expect(AppThemeMode.values, contains(AppThemeMode.light));
      expect(AppThemeMode.values, contains(AppThemeMode.you));
    });
  });
}
