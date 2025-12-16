import 'package:departures/enums/line_types.dart';
import 'package:departures/widgets/bus_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BusDisplay', () {
    testWidgets('should display departure information', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusDisplay(
              direction: 'Alexanderplatz',
              line: 'U8',
              lineType: LineType.subway,
              departureTime: departureTime,
              delay: 2,
              cancelled: false,
            ),
          ),
        ),
      );

      expect(find.text('Alexanderplatz'), findsOneWidget);
      expect(find.text('U8'), findsOneWidget);
    });

    testWidgets('should display on-time status', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusDisplay(
              direction: 'Alexanderplatz',
              line: 'U8',
              lineType: LineType.subway,
              departureTime: departureTime,
              delay: 0,
              cancelled: false,
            ),
          ),
        ),
      );

      expect(find.textContaining('±'), findsOneWidget);
    });

    testWidgets('should display delay', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusDisplay(
              direction: 'Alexanderplatz',
              line: 'U8',
              lineType: LineType.subway,
              departureTime: departureTime,
              delay: 5,
              cancelled: false,
            ),
          ),
        ),
      );

      expect(find.textContaining('+5'), findsOneWidget);
    });

    testWidgets('should display cancelled status', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusDisplay(
              direction: 'Alexanderplatz',
              line: 'U8',
              lineType: LineType.subway,
              departureTime: departureTime,
              delay: null,
              cancelled: true,
            ),
          ),
        ),
      );

      // When cancelled, delay information should not be shown
      expect(find.textContaining('('), findsNothing);
    });

    testWidgets('should display unknown delay', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusDisplay(
              direction: 'Hauptbahnhof',
              line: 'M48',
              lineType: LineType.bus,
              departureTime: departureTime,
              delay: null,
              cancelled: false,
            ),
          ),
        ),
      );

      expect(find.textContaining('(?)'), findsOneWidget);
    });

    testWidgets('should use correct color for line type', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusDisplay(
              direction: 'Alexanderplatz',
              line: 'U8',
              lineType: LineType.subway,
              departureTime: departureTime,
              delay: 0,
              cancelled: false,
            ),
          ),
        ),
      );

      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.backgroundColor, equals(LineType.subway.color));
    });

    testWidgets('should display different line types correctly', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      for (final lineType in LineType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BusDisplay(
                direction: 'Test Direction',
                line: 'TEST',
                lineType: lineType,
                departureTime: departureTime,
                delay: 0,
                cancelled: false,
              ),
            ),
          ),
        );

        final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(circleAvatar.backgroundColor, equals(lineType.color));
      }
    });

    testWidgets('should handle negative delay', (WidgetTester tester) async {
      final departureTime = DateTime(2024, 12, 15, 14, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BusDisplay(
              direction: 'Alexanderplatz',
              line: 'U8',
              lineType: LineType.subway,
              departureTime: departureTime,
              delay: -2,
              cancelled: false,
            ),
          ),
        ),
      );

      expect(find.textContaining('-2'), findsOneWidget);
    });
  });
}
