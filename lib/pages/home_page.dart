import 'package:departures/enums/line_types.dart';
import 'package:departures/services/api.dart';
import 'package:departures/services/stop.dart';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final lineTypeNames = LineType.values.map((e) => e.name);
  List<Stop> _nearbyStations = [];
  String emptyListExplanation = "";

  bool _isProgrammaticRefresh = false;
  int _nearbyStationsCount = 10;

  Future<Position?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        emptyListExplanation = _appLocalizations!.locationNotEnabled;
      });

      if (!mounted) return null;
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(_appLocalizations!.locationNotEnabledError),
          content: Text(_appLocalizations!.locationDisabledAdvice),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_appLocalizations!.close),
            ),
            TextButton(
              onPressed: () {
                Geolocator.openLocationSettings();
                Navigator.pop(context);
              },
              child: Text(_appLocalizations!.openSettings),
            ),
          ],
        ),
      );

      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          emptyListExplanation = _appLocalizations!.locationCouldNotBeAccessed;
        });

        if (!mounted) return null;
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(_appLocalizations!.permissionsError),
            content: Text(_appLocalizations!.locationPermissionDeniedAdvice),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(_appLocalizations!.close),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                  Navigator.pop(context);
                },
                child: Text(_appLocalizations!.openSettings),
              ),
            ],
          ),
        );

        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        emptyListExplanation = _appLocalizations!.locationCouldNotBeAccessed;
      });

      if (!mounted) return null;
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(_appLocalizations!.permissionsError),
          content: Text(_appLocalizations!.locationPermissionDeniedAdvice),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_appLocalizations!.close),
            ),
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.pop(context);
              },
              child: Text(_appLocalizations!.openSettings),
            ),
          ],
        ),
      );

      return null;
    }

    final LocationAccuracyStatus accuracy =
        await Geolocator.getLocationAccuracy();

    if (!(accuracy == LocationAccuracyStatus.precise)) {
      setState(() {
        emptyListExplanation = _appLocalizations!.locationNotPrecise;
      });

      if (!mounted) return null;
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(_appLocalizations!.permissionsError),
          content: Text(_appLocalizations!.locationNotPreciseAdvice),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_appLocalizations!.close),
            ),
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.pop(context);
              },
              child: Text(_appLocalizations!.openSettings),
            ),
          ],
        ),
      );

      return null;
    }

    return Geolocator.getCurrentPosition();
  }

  Future<void> _updateNearbyStations() async {
    if (_isProgrammaticRefresh) {
      setState(() {
        _nearbyStationsCount += 10;
      });
    } else {
      setState(() {
        _nearbyStationsCount = 10;
      });
    }

    setState(() {
      _isProgrammaticRefresh = false;
    });

    final Position? locationData = await _getLocation();

    if (locationData == null || !mounted) {
      return;
    }

    final nearbyStations = await VbbApi.getNearbyStations(
      locationData.latitude,
      locationData.longitude,
      context,
      count: _nearbyStationsCount,
    );

    setState(() {
      _nearbyStations = nearbyStations;
    });
  }

  Widget _buildEmptyListView(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: constraints.maxWidth,
          minHeight: constraints.maxHeight,
        ),
        child: Center(
          child: Text(emptyListExplanation, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildStationListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _nearbyStations.length + 1,
      itemBuilder: (context, index) {
        if (index == _nearbyStations.length) {
          return ListTile(
            title: Center(
              child: Text(
                _appLocalizations!.loadMore,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            onTap: () {
              _isProgrammaticRefresh = true;
              _refreshIndicatorKey.currentState?.show();
            },
          );
        }

        Map<String, LineType> lineTypes = {};
        for (final line in _nearbyStations[index].lines!) {
          if (lineTypeNames.contains(line.product) && line.name != null) {
            if (lineTypes.containsKey(line.name!)) continue;
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);
    emptyListExplanation = _appLocalizations!.homeNoNearbyStations;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            Text(
              AppLocalizations.of(context)!.nearbyStationsTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _updateNearbyStations,
        key: _refreshIndicatorKey,
        child: _nearbyStations.isEmpty
            ? LayoutBuilder(
                builder: (context, constraints) =>
                    _buildEmptyListView(context, constraints),
              )
            : _buildStationListView(context),
      ),
    );
  }
}
