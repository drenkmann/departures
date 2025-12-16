import 'package:departures/services/departure.dart';
import 'package:departures/services/stop.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Departure', () {
    test('should create Departure from JSON', () {
      final json = {
        'tripId': '1|123456|0|80|15122024',
        'when': '2024-12-15T14:30:00+01:00',
        'plannedWhen': '2024-12-15T14:28:00+01:00',
        'delay': 120,
        'platform': '2',
        'plannedPlatform': '2',
        'prognosisType': 'prognosed',
        'direction': 'Alexanderplatz',
        'cancelled': false,
        'line': {
          'type': 'line',
          'id': 'u8',
          'name': 'U8',
          'product': 'subway',
        },
        'destination': {
          'type': 'stop',
          'id': '900000100001',
          'name': 'Alexanderplatz',
        },
      };

      final departure = Departure.fromJson(json);

      expect(departure.tripId, equals('1|123456|0|80|15122024'));
      expect(departure.when, equals('2024-12-15T14:30:00+01:00'));
      expect(departure.plannedWhen, equals('2024-12-15T14:28:00+01:00'));
      expect(departure.delay, equals(120));
      expect(departure.platform, equals('2'));
      expect(departure.plannedPlatform, equals('2'));
      expect(departure.prognosisType, equals('prognosed'));
      expect(departure.direction, equals('Alexanderplatz'));
      expect(departure.cancelled, isFalse);
      expect(departure.line, isNotNull);
      expect(departure.line!.name, equals('U8'));
      expect(departure.destination, isNotNull);
      expect(departure.destination!.name, equals('Alexanderplatz'));
    });

    test('should convert Departure to JSON', () {
      final departure = Departure(
        tripId: '1|123456|0|80|15122024',
        when: '2024-12-15T14:30:00+01:00',
        plannedWhen: '2024-12-15T14:28:00+01:00',
        delay: 120,
        platform: '2',
        direction: 'Alexanderplatz',
        cancelled: false,
      );

      final json = departure.toJson();

      expect(json['tripId'], equals('1|123456|0|80|15122024'));
      expect(json['when'], equals('2024-12-15T14:30:00+01:00'));
      expect(json['plannedWhen'], equals('2024-12-15T14:28:00+01:00'));
      expect(json['delay'], equals(120));
      expect(json['platform'], equals('2'));
      expect(json['direction'], equals('Alexanderplatz'));
      expect(json['cancelled'], isFalse);
    });

    test('should handle null values in fromJson', () {
      final json = {
        'tripId': '1|123456|0|80|15122024',
      };

      final departure = Departure.fromJson(json);

      expect(departure.tripId, equals('1|123456|0|80|15122024'));
      expect(departure.when, isNull);
      expect(departure.delay, isNull);
      expect(departure.line, isNull);
      expect(departure.destination, isNull);
      expect(departure.cancelled, isNull);
    });

    test('should handle remarks in JSON', () {
      final json = {
        'tripId': '1|123456|0|80|15122024',
        'remarks': [
          {
            'type': 'hint',
            'code': 'text.hint.FB.disruption',
            'text': 'Service disruption',
          }
        ],
      };

      final departure = Departure.fromJson(json);

      expect(departure.remarks, isNotNull);
      expect(departure.remarks!.length, equals(1));
      expect(departure.remarks![0].type, equals('hint'));
      expect(departure.remarks![0].text, equals('Service disruption'));
    });

    test('should handle currentTripPosition in JSON', () {
      final json = {
        'tripId': '1|123456|0|80|15122024',
        'currentTripPosition': {
          'type': 'location',
          'latitude': 52.521512,
          'longitude': 13.411267,
        },
      };

      final departure = Departure.fromJson(json);

      expect(departure.currentTripPosition, isNotNull);
      expect(departure.currentTripPosition!.type, equals('location'));
      expect(departure.currentTripPosition!.latitude, equals(52.521512));
      expect(departure.currentTripPosition!.longitude, equals(13.411267));
    });
  });

  group('Line', () {
    test('should create Line from JSON', () {
      final json = {
        'type': 'line',
        'id': 'u8',
        'fahrtNr': '12345',
        'name': 'U8',
        'public': true,
        'adminCode': 'VBB',
        'productName': 'U-Bahn',
        'mode': 'train',
        'product': 'subway',
      };

      final line = Line.fromJson(json);

      expect(line.type, equals('line'));
      expect(line.id, equals('u8'));
      expect(line.fahrtNr, equals('12345'));
      expect(line.name, equals('U8'));
      expect(line.public, isTrue);
      expect(line.adminCode, equals('VBB'));
      expect(line.productName, equals('U-Bahn'));
      expect(line.mode, equals('train'));
      expect(line.product, equals('subway'));
    });

    test('should convert Line to JSON', () {
      final line = Line(
        type: 'line',
        id: 'u8',
        name: 'U8',
        public: true,
        productName: 'U-Bahn',
        mode: 'train',
        product: 'subway',
      );

      final json = line.toJson();

      expect(json['type'], equals('line'));
      expect(json['id'], equals('u8'));
      expect(json['name'], equals('U8'));
      expect(json['public'], isTrue);
      expect(json['productName'], equals('U-Bahn'));
      expect(json['mode'], equals('train'));
      expect(json['product'], equals('subway'));
    });

    test('should handle operator in JSON', () {
      final json = {
        'type': 'line',
        'id': 'u8',
        'name': 'U8',
        'operator': {
          'type': 'operator',
          'id': 'bvg',
          'name': 'BVG',
        },
      };

      final line = Line.fromJson(json);

      expect(line.operator, isNotNull);
      expect(line.operator!.type, equals('operator'));
      expect(line.operator!.id, equals('bvg'));
      expect(line.operator!.name, equals('BVG'));
    });
  });

  group('Operator', () {
    test('should create Operator from JSON', () {
      final json = {
        'type': 'operator',
        'id': 'bvg',
        'name': 'BVG',
      };

      final operator = Operator.fromJson(json);

      expect(operator.type, equals('operator'));
      expect(operator.id, equals('bvg'));
      expect(operator.name, equals('BVG'));
    });

    test('should convert Operator to JSON', () {
      final operator = Operator(type: 'operator', id: 'bvg', name: 'BVG');

      final json = operator.toJson();

      expect(json['type'], equals('operator'));
      expect(json['id'], equals('bvg'));
      expect(json['name'], equals('BVG'));
    });
  });

  group('Remarks', () {
    test('should create Remarks from JSON', () {
      final json = {
        'type': 'hint',
        'code': 'text.hint.FB.disruption',
        'text': 'Service disruption',
      };

      final remarks = Remarks.fromJson(json);

      expect(remarks.type, equals('hint'));
      expect(remarks.code, equals('text.hint.FB.disruption'));
      expect(remarks.text, equals('Service disruption'));
    });

    test('should convert Remarks to JSON', () {
      final remarks = Remarks(
        type: 'hint',
        code: 'text.hint.FB.disruption',
        text: 'Service disruption',
      );

      final json = remarks.toJson();

      expect(json['type'], equals('hint'));
      expect(json['code'], equals('text.hint.FB.disruption'));
      expect(json['text'], equals('Service disruption'));
    });
  });

  group('CurrentTripPosition', () {
    test('should create CurrentTripPosition from JSON', () {
      final json = {
        'type': 'location',
        'latitude': 52.521512,
        'longitude': 13.411267,
      };

      final position = CurrentTripPosition.fromJson(json);

      expect(position.type, equals('location'));
      expect(position.latitude, equals(52.521512));
      expect(position.longitude, equals(13.411267));
    });

    test('should convert CurrentTripPosition to JSON', () {
      final position = CurrentTripPosition(
        type: 'location',
        latitude: 52.521512,
        longitude: 13.411267,
      );

      final json = position.toJson();

      expect(json['type'], equals('location'));
      expect(json['latitude'], equals(52.521512));
      expect(json['longitude'], equals(13.411267));
    });
  });
}
