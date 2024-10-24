import 'package:departures/line_types.dart';
import 'package:departures/services/vbb_api.dart';
import 'package:departures/services/stop.dart';
import 'package:departures/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  AppLocalizations? _appLocalizations;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final Location location = Location();

  List<Stop> _nearbyStations = [];
  String emptyListExplanation = "";


  Future<LocationData?> _getLocation() async {
    try {
      final locationResult = await location.getLocation();
      return locationResult;
    } on PlatformException catch (err) {
      setState(() {
        emptyListExplanation = _appLocalizations!.locationCouldNotBeAccessed;
      });

      if (!mounted) return null;
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text(_appLocalizations!.permissionsError),
        content: Text(_appLocalizations!.locationCouldNotBeAccessedReason(err.code)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, _appLocalizations!.close),
            child: Text(_appLocalizations!.close),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context, _appLocalizations!.openSettings);
            },
            child: Text(_appLocalizations!.openSettings),
          ),
        ],
      ));
    }

    return null;
  }

  Future<void> _updateNearbyStations() async {
    final LocationData? locationData = await _getLocation();

    if (locationData == null || !mounted) {
      return;
    }

    final nearbyStations = await VbbApi.getNearbyStations(locationData.latitude!, locationData.longitude!, context);
    setState(() {
      _nearbyStations = nearbyStations;
    });
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);
    emptyListExplanation = _appLocalizations!.homeNoNearbyStations;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_appLocalizations!.nearbyStationsTitle, style: Theme.of(context).textTheme.headlineMedium,),
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

                return StationDisplay(
                  stationName: _nearbyStations[index].name!
                    .replaceAll("(Berlin)", "")
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
