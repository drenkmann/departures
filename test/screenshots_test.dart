import 'package:departures/enums/app_theme_modes.dart';
import 'package:departures/enums/line_types.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:departures/services/api.dart';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'golden_screenshot_test_utils.dart';
import 'widgets/test_app_main_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ScreenshotDevice.screenshotsFolder = '../docs/images/\$langCode/';

  final baseDevice = GoldenSmallDevices.androidPhone.device;
  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff0ca00)),
    // ignore: deprecated_member_use
    sliderTheme: const SliderThemeData(year2023: false),
  );
  final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xfff0ca00),
      brightness: Brightness.dark,
    ),
    // ignore: deprecated_member_use
    sliderTheme: const SliderThemeData(year2023: false),
  );
  final devices = [
    (
      label: 'androidPhone',
      device: ScreenshotDevice(
        platform: TargetPlatform.android,
        resolution: baseDevice.resolution,
        pixelRatio: baseDevice.pixelRatio,
        goldenSubFolder: './',
        frameBuilder: baseDevice.frameBuilder,
      ),
    ),
  ];
  final locales = [testLocaleEn, testLocaleDe];

  group('screenshots', () {
    for (final locale in locales) {
      group('locale ${locale.languageCode}', () {
        setUpAll(() async {
          final nearbyStops = await GoldenFixtureLoader.loadStops(
            'test/fixtures/nearby_stations.json',
          );
          final searchStops = await GoldenFixtureLoader.loadStops(
            'test/fixtures/search_results.json',
          );
          final departures = await GoldenFixtureLoader.loadDepartures(
            'test/fixtures/departures_900100003.json',
          );

          VbbApi.testNearbyStations = nearbyStops;
          VbbApi.testSearchStations = searchStops;
          VbbApi.testDepartures = departures;

          final favorites = nearbyStops.take(3).map((stop) {
            final lines = <String, LineType>{};
            for (final line in stop.lines ?? []) {
              if (line.name == null || line.product == null) continue;
              final product = line.product!;
              if (!LineType.values.any((type) => type.name == product)) {
                continue;
              }
              lines[line.name!] = LineType.values.byName(product);
            }
            return StationDisplay(
              stationName: stop.name!
                  .replaceAll('(Berlin)', '')
                  .replaceAll('[Tram]', '')
                  .replaceAll('[Bus]', '')
                  .trim(),
              stationId: stop.id!,
              lines: lines,
              distance: stop.distance,
            );
          }).toList();

          await GoldenTestDefaults.seedSharedPreferences(
            favorites: favorites,
            themeModeIndex: AppThemeMode.dark.index,
          );

          GeolocatorPlatform.instance = FakeGeolocatorPlatform(
            position: Position(
              longitude: 13.33239105360154,
              latitude: 52.507392913594366,
              timestamp: DateTime(2026, 2, 11, 12, 0),
              accuracy: 5,
              altitude: 34,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0,
            ),
          );
        });

        for (final goldenDevice in devices) {
          testGoldens('Home - ${goldenDevice.label}', (tester) async {
            await tester.pumpWidget(
              ScreenshotApp.withConditionalTitlebar(
                device: goldenDevice.device,
                title: 'Departures',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.dark,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: GoldenTestDefaults.buildApp(
                  home: const TestAppMainPage(initialIndex: 0),
                ),
              ),
            );

            await tester.loadAssets();
            await tester.pumpFrames(
              tester.widget(find.byType(ScreenshotApp)),
              const Duration(seconds: 1),
            );
            await tester.pumpAndSettle();

            await tester.expectScreenshot(
              goldenDevice.device,
              'Home',
              finder: find.byType(ScreenshotApp),
              langCode: locale.languageCode,
            );
          });

          testGoldens('Saved - ${goldenDevice.label}', (tester) async {
            await tester.pumpWidget(
              ScreenshotApp.withConditionalTitlebar(
                device: goldenDevice.device,
                title: 'Departures',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.dark,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: GoldenTestDefaults.buildApp(
                  home: const TestAppMainPage(initialIndex: 1),
                ),
              ),
            );

            await tester.loadAssets();
            await tester.pumpFrames(
              tester.widget(find.byType(ScreenshotApp)),
              const Duration(seconds: 1),
            );
            await tester.pumpAndSettle();

            await tester.expectScreenshot(
              goldenDevice.device,
              'Saved',
              finder: find.byType(ScreenshotApp),
              langCode: locale.languageCode,
            );
          });

          testGoldens('Search - ${goldenDevice.label}', (tester) async {
            await tester.pumpWidget(
              ScreenshotApp.withConditionalTitlebar(
                device: goldenDevice.device,
                title: 'Departures',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.dark,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: GoldenTestDefaults.buildApp(
                  home: const TestAppMainPage(initialIndex: 2),
                ),
              ),
            );

            await tester.enterText(find.byType(TextField), 'Hauptbahnhof');
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 200));

            await tester.loadAssets();
            await tester.pumpFrames(
              tester.widget(find.byType(ScreenshotApp)),
              const Duration(seconds: 1),
            );
            await tester.pumpAndSettle();

            await tester.expectScreenshot(
              goldenDevice.device,
              'Search',
              finder: find.byType(ScreenshotApp),
              langCode: locale.languageCode,
            );
          });

          testGoldens('Settings - ${goldenDevice.label}', (tester) async {
            await tester.pumpWidget(
              ScreenshotApp.withConditionalTitlebar(
                device: goldenDevice.device,
                title: 'Departures',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: ThemeMode.dark,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: GoldenTestDefaults.buildApp(
                  home: const TestAppMainPage(initialIndex: 3),
                ),
              ),
            );

            await tester.loadAssets();
            await tester.pumpFrames(
              tester.widget(find.byType(ScreenshotApp)),
              const Duration(seconds: 1),
            );
            await tester.pumpAndSettle();

            await tester.expectScreenshot(
              goldenDevice.device,
              'Settings',
              finder: find.byType(ScreenshotApp),
              langCode: locale.languageCode,
            );
          });
        }
      });
    }
  });
}
