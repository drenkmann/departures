import 'package:departures/provider/api_settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiSettingsProvider', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should have default values', () async {
      final provider = ApiSettingsProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.mainHost, equals(''));
      expect(provider.duration, equals(30));
    });

    test('should load saved host preference', () async {
      SharedPreferences.setMockInitialValues({'apiHost': 'custom.api.host'});

      final provider = ApiSettingsProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.mainHost, equals('custom.api.host'));
    });

    test('should load saved duration preference', () async {
      SharedPreferences.setMockInitialValues({'duration': 60});

      final provider = ApiSettingsProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.duration, equals(60));
    });

    test('should save host preference', () async {
      final provider = ApiSettingsProvider();
      await Future.delayed(Duration.zero);

      await provider.saveHost('new.api.host');
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('apiHost'), equals('new.api.host'));
    });

    test('should set and save duration', () async {
      final provider = ApiSettingsProvider();
      await Future.delayed(Duration.zero);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.setDuration(45);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.duration, equals(45));
      expect(notified, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('duration'), equals(45));
    });

    test('should set main host', () async {
      final provider = ApiSettingsProvider();
      await Future.delayed(Duration.zero);

      provider.setMainHost('test.host.com');
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('apiHost'), equals('test.host.com'));
    });

    test('should notify listeners when duration changes', () async {
      final provider = ApiSettingsProvider();
      await Future.delayed(Duration.zero);

      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setDuration(60);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(notificationCount, greaterThan(0));
    });

    test('should use default duration if not set', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = ApiSettingsProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.duration, equals(30));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('duration'), equals(30));
    });

    test('should handle multiple duration updates', () async {
      final provider = ApiSettingsProvider();
      await Future.delayed(Duration.zero);

      final durations = [15, 30, 45, 60, 90];
      for (final duration in durations) {
        provider.setDuration(duration);
        await Future.delayed(const Duration(milliseconds: 50));
        expect(provider.duration, equals(duration));
      }
    });
  });
}
