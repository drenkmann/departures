import 'package:departures/enums/line_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LineType', () {
    test('should have correct color for bus', () {
      expect(LineType.bus.color, equals(const Color(0xffa5027d)));
    });

    test('should have correct color for subway', () {
      expect(LineType.subway.color, equals(const Color(0xff004f8d)));
    });

    test('should have correct color for suburban', () {
      expect(LineType.suburban.color, equals(const Color(0xff008d4f)));
    });

    test('should have correct color for tram', () {
      expect(LineType.tram.color, equals(const Color(0xffd82020)));
    });

    test('should have correct color for ferry', () {
      expect(LineType.ferry.color, equals(const Color(0xff0080ba)));
    });

    test('should have correct color for regional', () {
      expect(LineType.regional.color, equals(const Color(0xffda251d)));
    });

    test('should have correct color for express', () {
      expect(LineType.express.color, equals(const Color(0xfff01414)));
    });

    test('should have seven values', () {
      expect(LineType.values.length, equals(7));
    });

    test('should contain all expected values', () {
      expect(LineType.values, contains(LineType.bus));
      expect(LineType.values, contains(LineType.subway));
      expect(LineType.values, contains(LineType.suburban));
      expect(LineType.values, contains(LineType.tram));
      expect(LineType.values, contains(LineType.ferry));
      expect(LineType.values, contains(LineType.regional));
      expect(LineType.values, contains(LineType.express));
    });
  });
}
