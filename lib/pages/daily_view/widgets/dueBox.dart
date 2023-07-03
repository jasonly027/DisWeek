import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/Task.dart';

class Due extends StatelessWidget {
  const Due({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    String monthDay = DateFormat.MMMMd().format(task.due!);

    return Container(
      margin: const EdgeInsets.all(2),
      child: Text("Due $monthDay",
          style: TextStyle(
              color:
                  Task.isUrgent(task) ? theme.error : theme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              shadows: const [Shadow(blurRadius: 1)])),
    );
  }
}
