import 'package:departures/line_types.dart';
import 'package:departures/services/vbb_api.dart';
import 'package:departures/services/nearby_stations.dart';
import 'package:departures/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final Location location = Location();

  List<NearbyStation> _nearbyStations = [];
  String emptyListExplanation = "No nearby stations found.";


  Future<LocationData?> _getLocation() async {
    try {
      final locationResult = await location.getLocation();
      return locationResult;
    } on PlatformException catch (err) {
      setState(() {
        emptyListExplanation = "Location could not be accessed.\nPlease check your permission settings and restart the app.";
      });

      if (!mounted) return null;
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: const Text("Permissions Error"),
        content: Text("Couldn't access location:\n${err.code}"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, "Close"),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context, "Open Settings");
            },
            child: const Text("Open Settings"),
          ),
        ],
      ));
    }

    return null;
  }

  Future<void> _updateNearbyStations() async {
    final LocationData? locationData = await _getLocation();

    if (locationData == null) {
      return;
    }

    final nearbyStations = await VbbApi.getNearbyStations(locationData.latitude!, locationData.longitude!);
    setState(() {
      _nearbyStations = nearbyStations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Nearby Stations", style: Theme.of(context).textTheme.headlineMedium,),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _updateNearbyStations,
            key: _refreshIndicatorKey,
            child: _nearbyStations.isEmpty
              ? LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Text(
                        emptyListExplanation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _nearbyStations.length,
              itemBuilder: (context, index) {
                Map<String, LineType> lineTypes = {};

                for (final line in _nearbyStations[index].lines!) {
                  if (LineType.values.map((e) => e.name).contains(line.product)) {
                    lineTypes[line.name!] = LineType.values.byName(line.product!);
                  }
                }

                final RegExp regExp = RegExp(r'\(.*?\)|\[.*?\]');

                return StationDisplay(
                  stationName: _nearbyStations[index].name!
                    .replaceAll(regExp, "")
                    .replaceAll(RegExp(r'\s+'), ' ')
                    .trim(),
                  stationId: _nearbyStations[index].id!,
                  lines: lineTypes,
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}
