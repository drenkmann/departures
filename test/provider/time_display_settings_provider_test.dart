import 'package:departures/provider/time_display_settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimeDisplaySettingsProvider', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should have default value as true for showActualTime', () async {
      final provider = TimeDisplaySettingsProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.showActualTime, isTrue);
    });

    test('should load saved preference', () async {
      SharedPreferences.setMockInitialValues({'showActualTime': false});

      final provider = TimeDisplaySettingsProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.showActualTime, isFalse);
    });

    test('should save and update showActualTime', () async {
      final provider = TimeDisplaySettingsProvider();
      await Future.delayed(Duration.zero);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.setShowActualTime(false);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.showActualTime, isFalse);
      expect(notified, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('showActualTime'), isFalse);
    });

    test('should save time display preference directly', () async {
      final provider = TimeDisplaySettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.saveTimeDisplayPreference(false);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.showActualTime, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('showActualTime'), isFalse);
    });

    test('should notify listeners when value changes', () async {
      final provider = TimeDisplaySettingsProvider();
      await Future.delayed(Duration.zero);

      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      await provider.setShowActualTime(false);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notificationCount, greaterThan(0));
    });

    test('should toggle between true and false', () async {
      final provider = TimeDisplaySettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.setShowActualTime(false);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.showActualTime, isFalse);

      await provider.setShowActualTime(true);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.showActualTime, isTrue);

      await provider.setShowActualTime(false);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.showActualTime, isFalse);
    });
  });
}
