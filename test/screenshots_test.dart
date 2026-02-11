import 'package:departures/enums/app_theme_modes.dart';
import 'package:departures/enums/line_types.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:departures/services/departure.dart' hide Color;
import 'package:departures/services/stop.dart' hide Color;
import 'package:departures/services/api.dart';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

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
        late List<Stop> nearbyStops;
        late List<Stop> searchStops;
        late List<Departure> departures;
        late String nearbyStopsJson;
        late String searchStopsJson;
        late String departuresJson;

        setUpAll(() async {
          nearbyStopsJson = await rootBundle.loadString(
            'test/fixtures/nearby_stations.json',
          );
          searchStopsJson = await rootBundle.loadString(
            'test/fixtures/search_results.json',
          );
          departuresJson = await rootBundle.loadString(
            'test/fixtures/departures_900100003.json',
          );

          nearbyStops = await GoldenFixtureLoader.loadStops(
            'test/fixtures/nearby_stations.json',
          );
          searchStops = await GoldenFixtureLoader.loadStops(
            'test/fixtures/search_results.json',
          );
          departures = await GoldenFixtureLoader.loadDepartures(
            'test/fixtures/departures_900100003.json',
          );

          VbbApi.client = MockClient((request) async {
            if (request.url.path == '/locations/nearby') {
              return http.Response(nearbyStopsJson, 200);
            }
            if (request.url.path == '/locations') {
              return http.Response(searchStopsJson, 200);
            }
            if (request.url.path.contains('/departures')) {
              return http.Response(departuresJson, 200);
            }
            return http.Response('[]', 200);
          });

          ConnectivityPlatform.instance = _FakeConnectivityPlatform();

          final favorites = nearbyStops.take(3).map((stop) {
            final lines = <String, LineType>{};
            for (final line in stop.lines ?? const []) {
              if (line.name == null || line.product == null) continue;
              final product = line.product!;
              if (!LineType.values.any((type) => type.name == product)) {
                continue;
              }
              lines[line.name!] = LineType.values.byName(product);
            }
            final stationName = (stop.name ?? '')
                .replaceAll('(Berlin)', '')
                .replaceAll('[Tram]', '')
                .replaceAll('[Bus]', '')
                .trim();
            return StationDisplay(
              stationName: stationName,
              stationId: stop.id ?? '',
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
            await tester.pump(const Duration(milliseconds: 200));

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
            await tester.pump(const Duration(milliseconds: 200));

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

            await tester.loadAssets();
            await tester.pumpFrames(
              tester.widget(find.byType(ScreenshotApp)),
              const Duration(seconds: 1),
            );
            await tester.pump(const Duration(milliseconds: 200));

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
            await tester.pump(const Duration(milliseconds: 200));

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

class _FakeConnectivityPlatform extends ConnectivityPlatform {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => [
    ConnectivityResult.wifi,
  ];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.value([ConnectivityResult.wifi]);
}
