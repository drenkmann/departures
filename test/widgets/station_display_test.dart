import 'package:departures/enums/line_types.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:departures/provider/distance_settings_provider.dart';
import 'package:departures/provider/favorites_provider.dart';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StationDisplay', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should display station name', (WidgetTester tester) async {
      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FavoritesProvider()),
                ChangeNotifierProvider(
                  create: (_) => DistanceSettingsProvider(),
                ),
              ],
              child: station,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Alexanderplatz'), findsOneWidget);
    });

    testWidgets('should display lines', (WidgetTester tester) async {
      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway, 'M48': LineType.bus},
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FavoritesProvider()),
                ChangeNotifierProvider(
                  create: (_) => DistanceSettingsProvider(),
                ),
              ],
              child: station,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('U8'), findsOneWidget);
      expect(find.text('M48'), findsOneWidget);
    });

    testWidgets('should display distance when provided', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'showDistance': true});
      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
        distance: 150,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FavoritesProvider()),
                ChangeNotifierProvider(
                  create: (_) => DistanceSettingsProvider(),
                ),
              ],
              child: station,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('150m'), findsOneWidget);
    });

    testWidgets('should not display distance when not provided', (
      WidgetTester tester,
    ) async {
      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FavoritesProvider()),
                ChangeNotifierProvider(
                  create: (_) => DistanceSettingsProvider(),
                ),
              ],
              child: station,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('m'), findsNothing);
    });

    testWidgets('should handle empty line names', (WidgetTester tester) async {
      final station = StationDisplay(
        stationName: 'Test Station',
        stationId: '900000100001',
        lines: {'': LineType.subway, 'U8': LineType.subway},
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FavoritesProvider()),
                ChangeNotifierProvider(
                  create: (_) => DistanceSettingsProvider(),
                ),
              ],
              child: station,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Empty line names should not be displayed
      expect(find.text('U8'), findsOneWidget);
      expect(find.byType(LineTag), findsOneWidget);
    });

    testWidgets('toJson should serialize station correctly', (
      WidgetTester tester,
    ) async {
      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway, 'M48': LineType.bus},
      );

      final json = station.toJson();

      expect(json['stationName'], equals('Alexanderplatz'));
      expect(json['stationId'], equals('900000100001'));
      expect(json['lines'], isA<Map>());
      expect(json['lines']['U8'], equals(LineType.subway.toString()));
      expect(json['lines']['M48'], equals(LineType.bus.toString()));
    });

    testWidgets('fromJson should deserialize station correctly', (
      WidgetTester tester,
    ) async {
      final json = {
        'stationName': 'Alexanderplatz',
        'stationId': '900000100001',
        'lines': {'U8': 'LineType.subway', 'M48': 'LineType.bus'},
      };

      final station = StationDisplay.fromJson(json);

      expect(station.stationName, equals('Alexanderplatz'));
      expect(station.stationId, equals('900000100001'));
      expect(station.lines['U8'], equals(LineType.subway));
      expect(station.lines['M48'], equals(LineType.bus));
    });
  });

  group('LineTag', () {
    testWidgets('should display line name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LineTag(lineType: LineType.subway, lineName: 'U8'),
          ),
        ),
      );

      expect(find.text('U8'), findsOneWidget);
    });

    testWidgets('should use correct color for line type', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LineTag(lineType: LineType.subway, lineName: 'U8'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(LineType.subway.color));
    });

    testWidgets('should display different line types with correct colors', (
      WidgetTester tester,
    ) async {
      for (final lineType in LineType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LineTag(lineType: lineType, lineName: 'TEST'),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(lineType.color));
      }
    });

    testWidgets('should have white text color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LineTag(lineType: LineType.subway, lineName: 'U8'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('U8'));
      expect(text.style?.color, equals(Colors.white));
    });

    testWidgets('should have rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LineTag(lineType: LineType.subway, lineName: 'U8'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(3)));
    });
  });
}
