import 'package:departures/services/stop.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Stop', () {
    test('should create Stop from JSON', () {
      final json = {
        'type': 'stop',
        'id': '900000100001',
        'name': 'Alexanderplatz',
        'location': {
          'type': 'location',
          'id': '900000100001',
          'latitude': 52.521512,
          'longitude': 13.411267,
        },
        'products': {
          'suburban': true,
          'subway': true,
          'tram': true,
          'bus': true,
          'ferry': false,
          'express': false,
          'regional': true,
        },
        'stationDHID': 'de:11000:900100001',
        'distance': 150,
      };

      final stop = Stop.fromJson(json);

      expect(stop.type, equals('stop'));
      expect(stop.id, equals('900000100001'));
      expect(stop.name, equals('Alexanderplatz'));
      expect(stop.location, isNotNull);
      expect(stop.location!.latitude, equals(52.521512));
      expect(stop.location!.longitude, equals(13.411267));
      expect(stop.products, isNotNull);
      expect(stop.products!.suburban, isTrue);
      expect(stop.products!.subway, isTrue);
      expect(stop.products!.ferry, isFalse);
      expect(stop.stationDHID, equals('de:11000:900100001'));
      expect(stop.distance, equals(150));
    });

    test('should convert Stop to JSON', () {
      final stop = Stop(
        type: 'stop',
        id: '900000100001',
        name: 'Alexanderplatz',
        location: StationLocation(
          type: 'location',
          id: '900000100001',
          latitude: 52.521512,
          longitude: 13.411267,
        ),
        distance: 150,
      );

      final json = stop.toJson();

      expect(json['type'], equals('stop'));
      expect(json['id'], equals('900000100001'));
      expect(json['name'], equals('Alexanderplatz'));
      expect(json['location'], isNotNull);
      expect(json['distance'], equals(150));
    });

    test('should handle null values in fromJson', () {
      final json = {
        'type': 'stop',
        'id': '900000100001',
        'name': 'Alexanderplatz',
      };

      final stop = Stop.fromJson(json);

      expect(stop.type, equals('stop'));
      expect(stop.id, equals('900000100001'));
      expect(stop.name, equals('Alexanderplatz'));
      expect(stop.location, isNull);
      expect(stop.products, isNull);
      expect(stop.lines, isNull);
      expect(stop.distance, isNull);
    });
  });

  group('StationLocation', () {
    test('should create StationLocation from JSON', () {
      final json = {
        'type': 'location',
        'id': '900000100001',
        'latitude': 52.521512,
        'longitude': 13.411267,
      };

      final location = StationLocation.fromJson(json);

      expect(location.type, equals('location'));
      expect(location.id, equals('900000100001'));
      expect(location.latitude, equals(52.521512));
      expect(location.longitude, equals(13.411267));
    });

    test('should convert StationLocation to JSON', () {
      final location = StationLocation(
        type: 'location',
        id: '900000100001',
        latitude: 52.521512,
        longitude: 13.411267,
      );

      final json = location.toJson();

      expect(json['type'], equals('location'));
      expect(json['id'], equals('900000100001'));
      expect(json['latitude'], equals(52.521512));
      expect(json['longitude'], equals(13.411267));
    });
  });

  group('Products', () {
    test('should create Products from JSON', () {
      final json = {
        'suburban': true,
        'subway': true,
        'tram': false,
        'bus': true,
        'ferry': false,
        'express': false,
        'regional': true,
      };

      final products = Products.fromJson(json);

      expect(products.suburban, isTrue);
      expect(products.subway, isTrue);
      expect(products.tram, isFalse);
      expect(products.bus, isTrue);
      expect(products.ferry, isFalse);
      expect(products.express, isFalse);
      expect(products.regional, isTrue);
    });

    test('should convert Products to JSON', () {
      final products = Products(
        suburban: true,
        subway: true,
        tram: false,
        bus: true,
        ferry: false,
        express: false,
        regional: true,
      );

      final json = products.toJson();

      expect(json['suburban'], isTrue);
      expect(json['subway'], isTrue);
      expect(json['tram'], isFalse);
      expect(json['bus'], isTrue);
      expect(json['ferry'], isFalse);
      expect(json['express'], isFalse);
      expect(json['regional'], isTrue);
    });
  });

  group('Lines', () {
    test('should create Lines from JSON', () {
      final json = {
        'type': 'line',
        'id': 'u8',
        'name': 'U8',
        'public': true,
        'productName': 'U-Bahn',
        'mode': 'train',
        'product': 'subway',
      };

      final lines = Lines.fromJson(json);

      expect(lines.type, equals('line'));
      expect(lines.id, equals('u8'));
      expect(lines.name, equals('U8'));
      expect(lines.public, isTrue);
      expect(lines.productName, equals('U-Bahn'));
      expect(lines.mode, equals('train'));
      expect(lines.product, equals('subway'));
    });

    test('should convert Lines to JSON', () {
      final lines = Lines(
        type: 'line',
        id: 'u8',
        name: 'U8',
        public: true,
        productName: 'U-Bahn',
        mode: 'train',
        product: 'subway',
      );

      final json = lines.toJson();

      expect(json['type'], equals('line'));
      expect(json['id'], equals('u8'));
      expect(json['name'], equals('U8'));
      expect(json['public'], isTrue);
      expect(json['productName'], equals('U-Bahn'));
      expect(json['mode'], equals('train'));
      expect(json['product'], equals('subway'));
    });

    test('should handle color in JSON', () {
      final json = {
        'type': 'line',
        'id': 'u8',
        'name': 'U8',
        'color': {
          'fg': '#FFFFFF',
          'bg': '#004F8D',
        },
      };

      final lines = Lines.fromJson(json);

      expect(lines.color, isNotNull);
      expect(lines.color!.fg, equals('#FFFFFF'));
      expect(lines.color!.bg, equals('#004F8D'));
    });
  });

  group('Color', () {
    test('should create Color from JSON', () {
      final json = {
        'fg': '#FFFFFF',
        'bg': '#004F8D',
      };

      final color = Color.fromJson(json);

      expect(color.fg, equals('#FFFFFF'));
      expect(color.bg, equals('#004F8D'));
    });

    test('should convert Color to JSON', () {
      final color = Color(fg: '#FFFFFF', bg: '#004F8D');

      final json = color.toJson();

      expect(json['fg'], equals('#FFFFFF'));
      expect(json['bg'], equals('#004F8D'));
    });
  });
}
