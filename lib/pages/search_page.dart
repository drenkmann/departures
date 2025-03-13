import 'package:departures/enums/line_types.dart';
import 'package:departures/services/stop.dart';
import 'package:departures/services/api.dart';
import 'package:departures/widgets/station_display.dart';
import 'package:flutter/material.dart';
import 'package:departures/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Stop> _stops = [];

  late TextEditingController _searchController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _getStops(String query) async {
    final stops = await VbbApi.getStations(query, context);

    setState(() {
      _stops = stops;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            Text(
              AppLocalizations.of(context)!.searchTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        edgeOffset: 56,
        key: _refreshIndicatorKey,
        onRefresh: () => _getStops(_searchController.text),
        notificationPredicate: (_) => false,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _stops.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onSubmitted: (_) => _refreshIndicatorKey.currentState?.show(),
                  onTapOutside: (event) {
                    _searchFocusNode.unfocus();
                  },
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  autofocus: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.searchBarPlaceholder,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            }

            Map<String, LineType> lineTypes = {};

            for (final line in _stops[index - 1].lines!) {
              if (LineType.values.map((e) => e.name).contains(line.product)) {
                lineTypes[line.name!] = LineType.values.byName(line.product!);
              }
            }

            return StationDisplay(
              stationName:
                  _stops[index - 1].name!.replaceAll("(Berlin)", "").trim(),
              stationId: _stops[index - 1].id!,
              lines: lineTypes,
            );
          },
        ),
      ),
    );
  }
}
