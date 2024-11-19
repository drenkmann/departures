import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:departures/services/departure.dart';
import 'package:departures/services/stop.dart';
import 'package:departures/services/station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VbbApi {
  VbbApi._();

  static String getIso8601FromTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final DateTime combinedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Get timezone offset in minutes
    final offset = now.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    return '${combinedDateTime.toIso8601String().substring(0, 19)}$sign$hours:$minutes';
  }

  static void _showError(BuildContext context, String errorMessage, {String? title, List<Widget>? actions}) async {
    if (!context.mounted) return;
      AppLocalizations appLocalizations = AppLocalizations.of(context)!;

      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text(title ?? appLocalizations.generalError),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(appLocalizations.ok),
          ),
          ...actions ?? [],
        ],
      ));
  }

  static Future<String> _getApiHost() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final host = prefs.getString("apiHost");
    if (host != null && host.isNotEmpty) {
      return host;
    } else {
      return "v6.vbb.transport.rest";
    }
  }

  static Future<bool> _hasInternetConnection() async {
    final connectivity = await Connectivity().checkConnectivity();

    return !connectivity.contains(ConnectivityResult.none);
  }

  static Future<List<Stop>> getNearbyStations(double latitude, double longitude, BuildContext context, {int? count}) async {
    if (!await _hasInternetConnection()) {
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.connectionErrorAdvice,
          title: AppLocalizations.of(context)!.connectionError,
        );
      }

      return [];
    }

    final String host = await _getApiHost();

    Uri uri = Uri(
      scheme: "https",
      host: host,
      path: "/locations/nearby",
      queryParameters: {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "linesOfStops": "true",
        "pretty": "false",
        if (count != null) "results": count.toString(),
      }
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Iterable stations = json.decode(response.body);
        List<Stop> nearbyStations = List<Stop>.from(stations.map((model) => Stop.fromJson(model)));

        return nearbyStations;
      }
      else {
        if (context.mounted) {
          _showError(
            context,
            "${response.statusCode}${response.reasonPhrase == null ? "" : " - ${response.reasonPhrase}"}",
            title: AppLocalizations.of(context)!.httpError
          );
        }

        return [];
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, e.toString());
      }

      return [];
    }
  }

  static Future<List<Departure>> getDeparturesAtStop(String stopId, BuildContext context, {TimeOfDay? when, int? duration}) async {
    if (!await _hasInternetConnection()) {
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.connectionErrorAdvice,
          title: AppLocalizations.of(context)!.connectionError,
        );
      }

      return [];
    }

    final String host = await _getApiHost();

    Uri uri = Uri(
      scheme: "https",
      host: host,
      path: "/stops/$stopId/departures",
      queryParameters: {
        "express": "false",
        "pretty": "false",
        "remarks": "false",
        "duration": duration?.toString() ?? "30",
        if (when != null) "when": getIso8601FromTimeOfDay(when),
      }
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> departuresAtStop = json.decode(response.body);
        List<Departure> departures = List<Departure>.from(departuresAtStop['departures'].map((model) => Departure.fromJson(model)));

        return departures;
      }
      else {
        if (context.mounted) {
          _showError(
            context,
            "${response.statusCode}${response.reasonPhrase == null ? "" : " - ${response.reasonPhrase}"}",
            title: AppLocalizations.of(context)!.httpError
          );
        }

        return [];
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, e.toString());
      }

      return [];
    }
  }

  static Future<Stop?> getStationInfo(BuildContext context, String stopId) async {
    if (!await _hasInternetConnection()) {
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.connectionErrorAdvice,
          title: AppLocalizations.of(context)!.connectionError,
        );
      }

      return null;
    }

    final String host = await _getApiHost();

    Uri uri = Uri(
      scheme: "https",
      host: host,
      path: "/stops/$stopId",
      queryParameters: {
        "linesOfStops": "true",
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Stop info = Stop.fromJson(json.decode(response.body));

        return info;
      }
      else {
        if (context.mounted) {
          _showError(
            context,
            "${response.statusCode}${response.reasonPhrase == null ? "" : " - ${response.reasonPhrase}"}",
            title: AppLocalizations.of(context)!.httpError
          );
        }

        return null;
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, e.toString());
      }

      return null;
    }
  }

  static Future<List<Stop>> getStations(String query, BuildContext context) async {
    if (!await _hasInternetConnection()) {
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.connectionErrorAdvice,
          title: AppLocalizations.of(context)!.connectionError,
        );
      }

      return [];
    }

    final String host = await _getApiHost();

    Uri uri = Uri(
      scheme: "https",
      host: host,
      path: "/stations",
      queryParameters: {
        "query": query,
        "results": "10",
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        Map<String, dynamic> stationsRaw = json.decode(response.body);
        List<Stop> stations = [];
        List<String> usedIds = [];

        for (var v in stationsRaw.values) {
          Station station = Station.fromJson(v);
          String id = station.id!.split(":")[2];
          if (!usedIds.contains(id) && context.mounted){
            Stop? stop = await getStationInfo(context, id);
            if (stop != null) {
              stations.add(stop);
            }
            usedIds.add(id);
          }
        }

        return stations;
      }
      else {
        if (context.mounted) {
          _showError(
            context,
            "${response.statusCode}${response.reasonPhrase == null ? "" : " - ${response.reasonPhrase}"}",
            title: AppLocalizations.of(context)!.httpError
          );
        }

        return [];
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, e.toString());
      }

      return [];
    }
  }
}