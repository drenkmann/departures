import 'package:departures/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VbbApi', () {
    group('getIso8601FromTimeOfDay', () {
      test('should convert TimeOfDay to ISO 8601 format', () {
        final timeOfDay = const TimeOfDay(hour: 14, minute: 30);
        final iso8601 = VbbApi.getIso8601FromTimeOfDay(timeOfDay);

        // The result should contain the time portion
        expect(iso8601, contains('14:30:00'));
        // Should include timezone offset
        expect(
          iso8601,
          matches(RegExp(r'\d{4}-\d{2}-\d{2}T14:30:00[+-]\d{2}:\d{2}')),
        );
      });

      test('should handle midnight', () {
        final timeOfDay = const TimeOfDay(hour: 0, minute: 0);
        final iso8601 = VbbApi.getIso8601FromTimeOfDay(timeOfDay);

        expect(iso8601, contains('00:00:00'));
        expect(
          iso8601,
          matches(RegExp(r'\d{4}-\d{2}-\d{2}T00:00:00[+-]\d{2}:\d{2}')),
        );
      });

      test('should handle noon', () {
        final timeOfDay = const TimeOfDay(hour: 12, minute: 0);
        final iso8601 = VbbApi.getIso8601FromTimeOfDay(timeOfDay);

        expect(iso8601, contains('12:00:00'));
        expect(
          iso8601,
          matches(RegExp(r'\d{4}-\d{2}-\d{2}T12:00:00[+-]\d{2}:\d{2}')),
        );
      });

      test('should handle end of day', () {
        final timeOfDay = const TimeOfDay(hour: 23, minute: 59);
        final iso8601 = VbbApi.getIso8601FromTimeOfDay(timeOfDay);

        expect(iso8601, contains('23:59:00'));
        expect(
          iso8601,
          matches(RegExp(r'\d{4}-\d{2}-\d{2}T23:59:00[+-]\d{2}:\d{2}')),
        );
      });

      test('should use current date for the datetime', () {
        final now = DateTime.now();
        final timeOfDay = const TimeOfDay(hour: 14, minute: 30);
        final iso8601 = VbbApi.getIso8601FromTimeOfDay(timeOfDay);

        // Should contain current year
        expect(iso8601, contains(now.year.toString()));
        // Should contain current month (padded)
        expect(iso8601, contains(now.month.toString().padLeft(2, '0')));
        // Should contain current day (padded)
        expect(iso8601, contains(now.day.toString().padLeft(2, '0')));
      });
    });
  });
}
