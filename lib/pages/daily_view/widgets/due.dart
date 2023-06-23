import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class due extends StatelessWidget {
  const due({
    super.key,
    required this.date,
    required this.theme,
  });

  final DateTime? date;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    if (date == null) {return const SizedBox.shrink();}
    String monthDay = DateFormat.MMMMd().format(date!);

    return Container(
      margin: const EdgeInsets.all(2),
      child: Text("Due $monthDay",
          style: TextStyle(
            color: theme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          )),
    );
  }
}
