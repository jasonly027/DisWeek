import 'package:dis_week/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../task_view/widgets/headerText.dart';

class DoDay extends StatefulWidget {
  const DoDay({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  State<DoDay> createState() => _DoDayState();
}

class _DoDayState extends State<DoDay> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    String doDay = DateFormat("MMMM d").format(widget.task.doDay);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          DateTime? tempDate = await _pickDate(widget.task.doDay);
          if (tempDate == null) return;

          setState(() {
            widget.task.doDay = tempDate;
            TaskDatabase.instance.updateTask(widget.task);
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryContainer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: FittedBox(
            child: headerText(
          text: doDay,
          textColor: theme.onPrimaryContainer,
          marginTop: 0,
        )),
      ),
    );
  }

  Future<DateTime?> _pickDate(DateTime? date) => showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)));
}
