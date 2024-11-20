import 'package:departures/enums/line_types.dart';
import 'package:departures/widgets/station_departures.dart';
import 'package:flutter/material.dart';

class StationDisplay extends StatelessWidget {
  const StationDisplay({
    super.key,
    required this.stationName,
    required this.lines,
    required this.stationId,
  });

  final String stationName;
  final String stationId;
  final Map lines;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(stationName),
      subtitle: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: [
            for (final line in lines.entries)
              if ((line.key as String).isNotEmpty)
                LineTag(lineType: line.value, lineName: line.key)
          ]
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          builder: (BuildContext context) {
            return StationDepartures(stationName: stationName, stationId: stationId,);
          },
        );
      },
    );
  }
}

class LineTag extends StatelessWidget {
  const LineTag({
    super.key,
    required this.lineType,
    required this.lineName,
  });

  final LineType lineType;
  final String lineName;

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.only(left: 3, right: 3),
      decoration: BoxDecoration(
        color: lineType.color,
        borderRadius: BorderRadius.circular(3)
      ),
      child: Text(lineName, style: const TextStyle(color: Colors.white),),
    );
  }
}
