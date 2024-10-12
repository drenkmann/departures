import 'dart:convert';

import 'package:departures/services/departures_at_stop.dart';
import 'package:departures/services/nearby_stations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class VbbApi {
  VbbApi._();

  static Future<List<NearbyStation>> getNearbyStations(double latitude, double longitude, BuildContext context) async {
    final response = await http.get(
      Uri.parse("https://v6.bvg.transport.rest/locations/nearby?latitude=${latitude.toString()}&longitude=${longitude.toString()}&linesOfStops=true&pretty=false")
    );

    if (response.statusCode == 200) {
      Iterable stations = json.decode(response.body);
      List<NearbyStation> nearbyStations = List<NearbyStation>.from(stations.map((model) => NearbyStation.fromJson(model)));

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

      final response = await http.get(
        Uri.parse("https://v6.vbb.transport.rest/locations/nearby?latitude=${latitude.toString()}&longitude=${longitude.toString()}&linesOfStops=true&pretty=false")
      );

      if (response.statusCode == 200) {
        Iterable stations = json.decode(response.body);
        List<NearbyStation> nearbyStations = List<NearbyStation>.from(stations.map((model) => NearbyStation.fromJson(model)));

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
    final response = await http.get(
      Uri.parse("https://v6.bvg.transport.rest/stops/$stopId/departures?tram=false&ferry=false&express=false&regional=false&pretty=false&remarks=false&duration=30")
    );

    if (response.statusCode == 200) {
      DeparturesAtStop departuresAtStop = DeparturesAtStop.fromJson(json.decode(response.body));

      if (departuresAtStop.departures == null) {
        throw Exception("Failed to get departures at stop.");
      }
      return departuresAtStop.departures!;
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
      final response = await http.get(
        Uri.parse("https://v6.vbb.transport.rest/stops/$stopId/departures?tram=false&ferry=false&express=false&regional=false&pretty=false&remarks=false&duration=30")
      );

      if (response.statusCode == 200) {
        DeparturesAtStop departuresAtStop = DeparturesAtStop.fromJson(json.decode(response.body));

        if (departuresAtStop.departures == null) {
          throw Exception("Failed to get departures at stop.");
        }
        return departuresAtStop.departures!;
      }
      else {
        throw Exception("Failed to get departures at stop.");
      }
    }
    else {
      throw Exception("Failed to get departures at stop.");
    }
  }
}