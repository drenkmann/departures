import 'package:departures/line_types.dart';
import 'package:departures/services/stop.dart';
import 'package:departures/services/vbb_api.dart';
import 'package:departures/station_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Stop> _stops = [];

  FocusNode searchFocusNode = FocusNode();

  Future<void> _getStops(String query) async {
    setState(() {
      _stops = [];
    });

    final stops = await VbbApi.getStations(query, context);
    setState(() {
      _stops = stops;
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
            child: Text(AppLocalizations.of(context)!.searchTitle, style: Theme.of(context).textTheme.headlineMedium,),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onSubmitted: _getStops,
            onTapOutside: (event) {
              searchFocusNode.unfocus();
            },
            focusNode: searchFocusNode,
            autofocus: false,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _stops.length,
            itemBuilder:(context, index) {
              Map<String, LineType> lineTypes = {};

              for (final line in _stops[index].lines!) {
                if (LineType.values.map((e) => e.name).contains(line.product)) {
                  lineTypes[line.name!] = LineType.values.byName(line.product!);
                }
              }

              return StationDisplay(
                stationName: _stops[index].name!
                  .replaceAll("(Berlin)", "")
                  .trim(),
                stationId: _stops[index].id!,
                lines: lineTypes,
              );
            },
          )
        ),
      ],
    );
  }
}
