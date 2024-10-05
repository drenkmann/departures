import 'package:departures/bus_display.dart';
import 'package:departures/line_types.dart';
import 'package:departures/services/departures_at_stop.dart';
import 'package:departures/services/vbb_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StationDepartures extends StatefulWidget {
  const StationDepartures({
    super.key,
    required this.stationName,
    required this.stationId,
  });

  final String stationName;
  final String stationId;

  @override
  State<StationDepartures> createState() => _StationDeparturesState();
}

class _StationDeparturesState extends State<StationDepartures> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  String stationId = "";
  List<Departure> _departures = [];

  Future<void> _updateDepartures() async {
    final departures = await VbbApi.getDeparturesAtStop(stationId);

    setState(() {
      _departures = departures;
    });
  }

  @override
  Widget build(BuildContext context) {
    stationId = widget.stationId;

    return RefreshIndicator(
      onRefresh: _updateDepartures,
      key: _refreshIndicatorKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
              child: Text(widget.stationName, style: Theme.of(context).textTheme.headlineSmall,),
            ),
          ),
          const Divider(indent: 16, endIndent: 16,),
          Expanded(
            child: ListView.builder(
              itemCount: _departures.length,
              itemBuilder: (context, index) {
                return BusDisplay(
                  direction: _departures[index].direction!,
                  line: _departures[index].line!.name!,
                  lineType: LineType.values.byName(_departures[index].line!.product!),
                  departureTime: DateTime.parse(_departures[index].when == null ? _departures[index].plannedWhen! : _departures[index].when!).toLocal(),
                  delay: _departures[index].delay == null ? null : (_departures[index].delay! / 60).round(),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
