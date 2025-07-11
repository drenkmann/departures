import 'dart:async';

import 'package:departures/provider/api_settings_provider.dart';
import 'package:departures/provider/time_display_settings_provider.dart';
import 'package:departures/widgets/bus_display.dart';
import 'package:departures/enums/line_types.dart';
import 'package:departures/services/departure.dart';
import 'package:departures/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timeDisplaySettingsProvider = Provider.of<TimeDisplaySettingsProvider>(
      context,
    );
    _apiSettingsProvider = Provider.of<ApiSettingsProvider>(context);
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late TimeDisplaySettingsProvider _timeDisplaySettingsProvider;
  late ApiSettingsProvider _apiSettingsProvider;

  String stationId = "";
  List<Departure> _departures = [];

  bool _isProgrammaticRefresh = false;
  int _offset = 0;
  TimeOfDay? _when;

  DateTime getDisplayTime(Departure departure) {
    final departureTimeString = _timeDisplaySettingsProvider.showActualTime
        ? (departure.when ?? departure.plannedWhen!)
        : departure.plannedWhen!;
    return DateTime.parse(departureTimeString).toLocal();
  }

  Future<void> _updateDepartures() async {
    if (_isProgrammaticRefresh) {
      setState(() {
        _offset += _apiSettingsProvider.duration;
      });
    } else {
      setState(() {
        _offset = 0;
      });
    }

    setState(() {
      _isProgrammaticRefresh = false;
    });

    final departures = await VbbApi.getDeparturesAtStop(
      stationId,
      context,
      duration: _apiSettingsProvider.duration + _offset,
      when: _when,
    );
    departures.sort((a, b) {
      final timeA = getDisplayTime(a);
      final timeB = getDisplayTime(b);

      if (timeA.isBefore(timeB)) {
        return -1;
      } else if (timeA.isAfter(timeB)) {
        return 1;
      } else {
        return 0;
      }
    });

    setState(() {
      _departures = departures;
    });
  }

  void _changeWhenPopup() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _when ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _when = selectedTime;
        _offset = 0;
      });

      _refreshIndicatorKey.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    stationId = widget.stationId;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 0, bottom: 4),
                  child: Text(
                    widget.stationName,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: OutlinedButton(
                  onPressed: _changeWhenPopup,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    "${_when?.format(context) ?? TimeOfDay.now().format(context)} ",
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(indent: 16, endIndent: 16),
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
                          decoration: TextDecoration.underline,
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

                return Consumer<TimeDisplaySettingsProvider>(
                  builder: (context, timeDisplayProvider, child) => BusDisplay(
                    direction: _departures[index].direction!,
                    line: _departures[index].line!.name!,
                    lineType: LineType.values.byName(
                      _departures[index].line!.product!,
                    ),
                    departureTime: getDisplayTime(_departures[index]),
                    delay: _departures[index].delay == null
                        ? null
                        : (_departures[index].delay! / 60).round(),
                    cancelled: _departures[index].cancelled,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
