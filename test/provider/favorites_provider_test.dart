import 'package:departures/enums/line_types.dart';
import 'package:departures/provider/favorites_provider.dart';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesProvider', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize with empty favorites', () async {
      final provider = FavoritesProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.favorites, isEmpty);
    });

    test('should load favorites from SharedPreferences', () async {
      final favoritesJson = [
        '{"stationName":"Alexanderplatz","stationId":"900000100001","lines":{"U8":"LineType.subway","M48":"LineType.bus"}}',
      ];
      SharedPreferences.setMockInitialValues({'favorites': favoritesJson});

      final provider = FavoritesProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.favorites.length, equals(1));
      expect(provider.favorites[0].stationName, equals('Alexanderplatz'));
      expect(provider.favorites[0].stationId, equals('900000100001'));
    });

    test('should add favorite', () async {
      final provider = FavoritesProvider();
      await Future.delayed(Duration.zero);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );

      provider.toggleFavorite(station);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.favorites.length, equals(1));
      expect(provider.favorites[0].stationId, equals('900000100001'));
      expect(notified, isTrue);

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('favorites');
      expect(saved, isNotNull);
      expect(saved!.length, equals(1));
    });

    test('should remove favorite', () async {
      final provider = FavoritesProvider();
      await Future.delayed(Duration.zero);

      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );

      provider.toggleFavorite(station);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.favorites.length, equals(1));

      provider.toggleFavorite(station);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.favorites, isEmpty);
    });

    test('should not add duplicate favorites', () async {
      final provider = FavoritesProvider();
      await Future.delayed(Duration.zero);

      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );

      provider.toggleFavorite(station);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.favorites.length, equals(1));

      // Toggle again should remove it
      provider.toggleFavorite(station);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.favorites, isEmpty);
    });

    test('should move favorite from one position to another', () async {
      final provider = FavoritesProvider();
      await Future.delayed(Duration.zero);

      final station1 = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );
      final station2 = StationDisplay(
        stationName: 'Potsdamer Platz',
        stationId: '900000100002',
        lines: {'S1': LineType.suburban},
      );
      final station3 = StationDisplay(
        stationName: 'Hauptbahnhof',
        stationId: '900000100003',
        lines: {'S5': LineType.suburban},
      );

      provider.toggleFavorite(station1);
      provider.toggleFavorite(station2);
      provider.toggleFavorite(station3);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.favorites[0].stationId, equals('900000100001'));
      expect(provider.favorites[1].stationId, equals('900000100002'));
      expect(provider.favorites[2].stationId, equals('900000100003'));

      provider.moveFavorite(0, 2);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.favorites[0].stationId, equals('900000100002'));
      expect(provider.favorites[1].stationId, equals('900000100001'));
      expect(provider.favorites[2].stationId, equals('900000100003'));
    });

    test('should persist favorites to SharedPreferences', () async {
      final provider = FavoritesProvider();
      await Future.delayed(Duration.zero);

      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );

      provider.toggleFavorite(station);
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('favorites');
      expect(saved, isNotNull);
      expect(saved!.length, equals(1));
      expect(saved[0], contains('Alexanderplatz'));
      expect(saved[0], contains('900000100001'));
    });

    test('should notify listeners when favorites change', () async {
      final provider = FavoritesProvider();
      await Future.delayed(Duration.zero);

      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      final station = StationDisplay(
        stationName: 'Alexanderplatz',
        stationId: '900000100001',
        lines: {'U8': LineType.subway},
      );

      provider.toggleFavorite(station);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notificationCount, greaterThan(0));
    });

    test('should handle multiple favorites', () async {
      final provider = FavoritesProvider();
      await Future.delayed(Duration.zero);

      final stations = [
        StationDisplay(
          stationName: 'Alexanderplatz',
          stationId: '900000100001',
          lines: {'U8': LineType.subway},
        ),
        StationDisplay(
          stationName: 'Potsdamer Platz',
          stationId: '900000100002',
          lines: {'S1': LineType.suburban},
        ),
        StationDisplay(
          stationName: 'Hauptbahnhof',
          stationId: '900000100003',
          lines: {'S5': LineType.suburban},
        ),
      ];

      for (final station in stations) {
        provider.toggleFavorite(station);
      }
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.favorites.length, equals(3));
      expect(provider.favorites[0].stationId, equals('900000100001'));
      expect(provider.favorites[1].stationId, equals('900000100002'));
      expect(provider.favorites[2].stationId, equals('900000100003'));
    });
  });
}
