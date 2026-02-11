import 'dart:convert';

import 'package:departures/enums/app_theme_modes.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:departures/provider/api_settings_provider.dart';
import 'package:departures/provider/distance_settings_provider.dart';
import 'package:departures/provider/favorites_provider.dart';
import 'package:departures/provider/theme_settings_provider.dart';
import 'package:departures/provider/time_display_settings_provider.dart';
import 'package:departures/services/departure.dart';
import 'package:departures/services/stop.dart';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Locale testLocaleEn = Locale('en');
const Locale testLocaleDe = Locale('de');

class GoldenFixtureLoader {
  static Future<List<Stop>> loadStops(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = json.decode(jsonString) as List<dynamic>;
    return decoded
        .map((entry) => Stop.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Departure>> loadDepartures(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    final departures = decoded['departures'] as List<dynamic>;
    return departures
        .map((entry) => Departure.fromJson(entry as Map<String, dynamic>))
        .toList();
  }
}

class GoldenTestDefaults {
  static Future<void> seedSharedPreferences({
    required List<StationDisplay> favorites,
    int duration = 30,
    bool showActualTime = true,
    bool showDistance = true,
    int? themeModeIndex,
  }) async {
    final resolvedThemeModeIndex = themeModeIndex ?? AppThemeMode.dark.index;
    final favoritesJson = favorites
        .map((station) => jsonEncode(station.toJson()))
        .toList();

    SharedPreferences.setMockInitialValues({
      'favorites': favoritesJson,
      'duration': duration,
      'showActualTime': showActualTime,
      'showDistance': showDistance,
      'themeMode': resolvedThemeModeIndex,
    });

    PackageInfo.setMockInitialValues(
      appName: 'Departures',
      packageName: 'dev.drenkmann.departures',
      version: '2.4.1',
      buildNumber: '0',
      buildSignature: '',
      installerStore: 'com.android.vending',
    );
  }

  static Widget buildApp({required Widget home}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ApiSettingsProvider()),
        ChangeNotifierProvider(create: (_) => TimeDisplaySettingsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => DistanceSettingsProvider()),
      ],
      child: home,
    );
  }
}

class FakeGeolocatorPlatform extends GeolocatorPlatform {
  FakeGeolocatorPlatform({
    required this.position,
    this.locationServiceEnabled = true,
    this.permission = LocationPermission.always,
    this.accuracyStatus = LocationAccuracyStatus.precise,
  });

  final Position position;
  final bool locationServiceEnabled;
  final LocationPermission permission;
  final LocationAccuracyStatus accuracyStatus;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Future<bool> isLocationServiceEnabled() async => locationServiceEnabled;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async => position;

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async => position;

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() async => accuracyStatus;
}
