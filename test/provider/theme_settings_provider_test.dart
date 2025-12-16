import 'package:departures/enums/app_theme_modes.dart';
import 'package:departures/provider/theme_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should have default theme mode as system', () async {
      final provider = ThemeProvider();
      await Future.delayed(Duration.zero); // Let async constructor complete

      expect(provider.appThemeMode, equals(AppThemeMode.system));
      expect(provider.materialYou, isFalse);
    });

    test('should return true for materialYou when theme is you', () async {
      SharedPreferences.setMockInitialValues({'themeMode': AppThemeMode.you.index});
      
      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.appThemeMode, equals(AppThemeMode.you));
      expect(provider.materialYou, isTrue);
    });

    test('should load saved theme preference', () async {
      SharedPreferences.setMockInitialValues({'themeMode': AppThemeMode.dark.index});

      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.appThemeMode, equals(AppThemeMode.dark));
    });

    test('should save and update theme mode', () async {
      final provider = ThemeProvider();
      await Future.delayed(Duration.zero);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.setThemeMode(AppThemeMode.dark);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.appThemeMode, equals(AppThemeMode.dark));
      expect(notified, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('themeMode'), equals(AppThemeMode.dark.index));
    });

    test('should save theme preference directly', () async {
      final provider = ThemeProvider();
      await Future.delayed(Duration.zero);

      await provider.saveThemePreference(AppThemeMode.light);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.appThemeMode, equals(AppThemeMode.light));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('themeMode'), equals(AppThemeMode.light.index));
    });

    test('should notify listeners when theme mode changes', () async {
      final provider = ThemeProvider();
      await Future.delayed(Duration.zero);

      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      await provider.setThemeMode(AppThemeMode.dark);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notificationCount, greaterThan(0));
    });

    test('should cycle through all theme modes', () async {
      final provider = ThemeProvider();
      await Future.delayed(Duration.zero);

      for (final mode in AppThemeMode.values) {
        await provider.setThemeMode(mode);
        await Future.delayed(const Duration(milliseconds: 50));
        expect(provider.appThemeMode, equals(mode));
      }
    });
  });
}
