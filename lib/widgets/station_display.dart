import 'package:departures/enums/line_types.dart';
import 'package:departures/provider/favorites_provider.dart';
import 'package:departures/provider/distance_settings_provider.dart';
import 'package:departures/widgets/station_departures.dart';
import 'package:flutter/material.dart';
import 'package:departures/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class StationDisplay extends StatelessWidget {
  StationDisplay({
    required this.stationName,
    required this.lines,
    required this.stationId,
    this.distance,
  }) : super(key: Key(stationId));

  final String stationName;
  final String stationId;
  final Map lines;
  final int? distance;

  Map<String, dynamic> toJson() {
    return {
      'stationName': stationName,
      'stationId': stationId,
      'lines': lines.map((key, value) => MapEntry(key, value.toString())),
    };
  }

  static StationDisplay fromJson(Map<String, dynamic> json) {
    return StationDisplay(
      stationName: json['stationName'],
      stationId: json['stationId'],
      lines: (json['lines'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          LineType.values.firstWhere((e) => e.toString() == value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(stationId),
      background: Container(
        color: theme.colorScheme.secondaryContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Icon(Icons.save, color: theme.colorScheme.onSecondaryContainer),
      ),
      secondaryBackground: Container(
        color: theme.colorScheme.secondaryContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Icon(Icons.save, color: theme.colorScheme.onSecondaryContainer),
      ),
      confirmDismiss: (_) {
        final provider = Provider.of<FavoritesProvider>(context, listen: false);
        var save = StationDisplay(
          stationName: stationName,
          stationId: stationId,
          lines: lines,
        );
        final justSaved = !provider.favorites.any(
          (fav) => fav.stationId == save.stationId,
        );
        provider.toggleFavorite(save);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appLocalizations.undoFavoriteToggle(
                justSaved.toString(),
                stationName,
              ),
            ),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: appLocalizations.undo,
              onPressed: () {
                provider.toggleFavorite(save);
              },
            ),
          ),
        );

        return Future.value(false);
      },
      child: ListTile(
        title: Row(
          children: [
            Text(stationName),
            const Spacer(),
            Consumer<DistanceSettingsProvider>(
              builder: (context, distanceSettingsProvider, child) {
                if (!distanceSettingsProvider.showDistance) {
                  return const SizedBox.shrink();
                }
                return Text(
                  ' (${distance}m)',
                  style: TextStyle(color: theme.hintColor),
                );
              },
            ),
            // if (distance != null)
            //   Text(' (${distance}m)', style: TextStyle(color: theme.hintColor)),
          ],
        ),
        subtitle: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            for (final line in lines.entries)
              if ((line.key as String).isNotEmpty)
                LineTag(lineType: line.value, lineName: line.key),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (BuildContext context) {
              return StationDepartures(
                stationName: stationName,
                stationId: stationId,
              );
            },
          );
        },
      ),
    );
  }
}

class LineTag extends StatelessWidget {
  const LineTag({super.key, required this.lineType, required this.lineName});

  final LineType lineType;
  final String lineName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 3, right: 3),
      decoration: BoxDecoration(
        color: lineType.color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(lineName, style: const TextStyle(color: Colors.white)),
    );
  }
}
