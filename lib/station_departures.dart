import 'package:departures/bus_display.dart';
import 'package:departures/line_types.dart';
import 'package:departures/services/departure.dart';
import 'package:departures/services/vbb_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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

  bool _isProgrammaticRefresh = false;
  int _duration = 30;

  Future<void> _updateDepartures() async {
    if (_isProgrammaticRefresh) {
      setState(() {
        _duration += 30;
      });
    } else {
      setState(() {
        _duration = 30;
      });
    }

    setState(() {
      _isProgrammaticRefresh = false;
    });

    final departures = await VbbApi.getDeparturesAtStop(stationId, context, duration: _duration, when: _when);
    departures.sort((a, b) {
      final timeA = DateTime.parse(a.when ?? a.plannedWhen!).toLocal();
      final timeB = DateTime.parse(b.when ?? b.plannedWhen!).toLocal();

      if (timeA.isBefore(timeB)) {
        return -1;
      } else if (timeA.isAfter(timeB)) {
        return 1;
      } else {
        return 0;
      }
    },);

    setState(() {
      _departures = departures;
    });
  }

  @override
  Widget build(BuildContext context) {
    stationId = widget.stationId;

    return Column(
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
          child: RefreshIndicator(
            onRefresh: _updateDepartures,
            key: _refreshIndicatorKey,
            child: ListView.builder(
              itemCount: _departures.length + 1,
              itemBuilder: (context, index) {
                if (index == _departures.length) {
                  return ListTile(
                    title: Center(
                      child: Text(
                        AppLocalizations.of(context)!.loadMore,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _isProgrammaticRefresh = true;
                      });
                      _refreshIndicatorKey.currentState?.show();
                    },
                  );
                }

                return BusDisplay(
                  direction: _departures[index].direction!,
                  line: _departures[index].line!.name!,
                  lineType: LineType.values.byName(_departures[index].line!.product!),
                  departureTime: DateTime.parse(_departures[index].when ?? _departures[index].plannedWhen!).toLocal(),
                  delay: _departures[index].delay == null ? null : (_departures[index].delay! / 60).round(),
                  cancelled: _departures[index].cancelled,
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}
