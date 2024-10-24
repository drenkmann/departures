import 'dart:convert';

import 'package:departures/services/departure.dart';
import 'package:departures/services/stop.dart';
import 'package:departures/services/station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VbbApi {
  VbbApi._();

  static Future<String> _getMainApiHost() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final host = prefs.getString("apiHost");
    if (host != null && host.isNotEmpty) {
      return host;
    } else {
      return "v6.bvg.transport.rest";
    }
  }

  static Future<String> _getFallbackApiHost() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final host = prefs.getString("fallbackApiHost");
    if (host != null && host.isNotEmpty) {
      return host;
    } else {
      return "v6.vbb.transport.rest";
    }
  }

  static Future<List<Stop>> getNearbyStations(double latitude, double longitude, BuildContext context) async {
    final String host = await _getMainApiHost();

    final response = await http.get(
      Uri(
        scheme: "https",
        host: host,
        path: "/locations/nearby",
        queryParameters: {
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "linesOfStops": "true",
          "pretty": "false",
        }
      )
    );

    if (response.statusCode == 200) {
      Iterable stations = json.decode(response.body);
      List<Stop> nearbyStations = List<Stop>.from(stations.map((model) => Stop.fromJson(model)));

      return nearbyStations;
    }
    else if (response.statusCode >= 500 && response.statusCode < 600) {
      if (!context.mounted) {
        return [];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.vbbFallbackMessage)
        )
      );

      final String fallbackHost = await _getFallbackApiHost();

      final response = await http.get(
        Uri(
          scheme: "https",
          host: fallbackHost,
          path: "/locations/nearby",
          queryParameters: {
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "linesOfStops": "true",
            "pretty": "false",
          }
        )
      );

      if (response.statusCode == 200) {
        Iterable stations = json.decode(response.body);
        List<Stop> nearbyStations = List<Stop>.from(stations.map((model) => Stop.fromJson(model)));

        return nearbyStations;
      }
      else {
        throw Exception("Failed to get nearby stations from API. Status code ${response.statusCode}");
      }
    }
    else {
      throw Exception("Failed to get nearby stations from API. Status code ${response.statusCode}");
    }
  }

  static Future<List<Departure>> getDeparturesAtStop(String stopId, BuildContext context) async {
    final String host = await _getMainApiHost();

    final response = await http.get(
      Uri(
        scheme: "https",
        host: host,
        path: "/stops/$stopId/departures",
        queryParameters: {
          "express": "false",
          "pretty": "false",
          "remarks": "false",
          "duration": "30",
        }
      )
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> departuresAtStop = json.decode(response.body);
      List<Departure> departures = List<Departure>.from(departuresAtStop['departures'].map((model) => Departure.fromJson(model)));

      return departures;
    }
    else if (response.statusCode >= 500 && response.statusCode < 600) {
      if (!context.mounted) {
        return [];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.vbbFallbackMessage)
        )
      );

      final String fallbackHost = await _getFallbackApiHost();

      final response = await http.get(
        Uri(
          scheme: "https",
          host: fallbackHost,
          path: "/stops/$stopId/departures",
          queryParameters: {
            "express": "false",
            "pretty": "false",
            "remarks": "false",
            "duration": "30",
          }
        )
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> departuresAtStop = json.decode(response.body);
        List<Departure> departures = List<Departure>.from(departuresAtStop['departures'].map((model) => Departure.fromJson(model)));

        return departures;
      }
      else {
        throw Exception("Failed to get departures at stop.");
      }
    }
    else {
      throw Exception("Failed to get departures at stop.");
    }
  }

  static Future<Stop> getStationInfo(String stopId) async {
    final String host = await _getMainApiHost();

    final response = await http.get(
      Uri(
        scheme: "https",
        host: host,
        path: "/stops/$stopId",
        queryParameters: {
          "linesOfStops": "true",
        },
      )
    );

    Stop info = Stop.fromJson(json.decode(response.body));

    return info;
  }

  static Future<List<Stop>> getStations(String query, BuildContext context) async {
    final String host = await _getMainApiHost();

    final response = await http.get(
      Uri(
        scheme: "https",
        host: host,
        path: "/stations",
        queryParameters: {
          "query": query,
          "results": "10",
        },
      )
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> stationsRaw = json.decode(response.body);
      List<Stop> stations = [];
      List<String> usedIds = [];

      for (var v in stationsRaw.values) {
        Station station = Station.fromJson(v);
        String id = station.id!.split(":")[2];
        if (!usedIds.contains(id)){
          stations.add(await getStationInfo(id));
          usedIds.add(id);
        }
      }

      return stations;
    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      if (!context.mounted) {
        return [];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.vbbFallbackMessage)
        )
      );

      final String fallbackHost = await _getFallbackApiHost();

      final response = await http.get(
        Uri(
          scheme: "https",
          host: fallbackHost,
          path: "/stations",
          queryParameters: {
            "query": query,
            "results": "10",
          },
        )
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> stationsRaw = json.decode(response.body);
        List<Stop> stationsOther = [];
        List<String> usedIds = [];

        for (var v in stationsRaw.values) {
          Station station = Station.fromJson(v);
          String id = station.id!.split(":")[2];
          if (!usedIds.contains(id)){
            stationsOther.add(await getStationInfo(id));
            usedIds.add(id);
          }
        }

        return stationsOther;
      }
      else {
        throw Exception("Failed to get stops.");
      }
    }
    else {
      throw Exception("Failed to get stops.");
    }
  }
}