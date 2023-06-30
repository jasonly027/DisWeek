import 'package:dis_week/pages/task_view/widgets/dueButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class due extends StatelessWidget {
  const due({
    super.key,
    required this.date,
    required this.theme,
  });

  final DateTime date;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    String monthDay = DateFormat.MMMMd().format(date);

    return Container(
      margin: const EdgeInsets.all(2),
      child: Text("Due $monthDay",
          style: TextStyle(
            color: DueButton.isUrgent(date) ? theme.error : theme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            shadows: const[Shadow(blurRadius: 1)]
          )),
    );
  }
}
