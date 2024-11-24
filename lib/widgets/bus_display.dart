import 'package:departures/enums/line_types.dart';
import 'package:flutter/material.dart';

class BusDisplay extends StatelessWidget {
  const BusDisplay({
    super.key,
    required this.direction,
    required this.line,
    required this.lineType,
    required this.departureTime,
    required this.delay,
    required this.cancelled,
  });

  final String direction;
  final String line;
  final LineType lineType;
  final DateTime departureTime;
  final num? delay;
  final bool? cancelled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: lineType.color, foregroundColor: Colors.white, child: Text(line),),
        title: Text(direction),
        leadingAndTrailingTextStyle: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.normal
        ),
        trailing: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: "${TimeOfDay.fromDateTime(departureTime).format(context)} ",
              style: cancelled ?? false
                ? const TextStyle(
                  color: Colors.redAccent,
                  decorationColor: Colors.redAccent,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                  height: 1.2
                )
                : null
            ),
            if (cancelled == null || (cancelled != null && !cancelled!)) TextSpan(
              text: delay == null ? "(?)" : "(${delay == 0 ? "±" : delay! > 0 ? "+" : ""}$delay)",
              style: delay == null
                ? const TextStyle(color: Colors.grey)
                : delay == 0
                  ? const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)
                  : const TextStyle(color: Colors.red, fontWeight: FontWeight.w500)
            )
          ])
        ),
      ),
    );
  }
}
