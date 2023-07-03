import 'package:dis_week/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'header.dart';

class DoDayButton extends StatefulWidget {
  const DoDayButton(
      {Key? key, required this.task, required this.tasks, required this.today})
      : super(key: key);

  final Task task;
  final List<Task>? tasks;
  final DateTime today;

  @override
  State<DoDayButton> createState() => _DoDayButtonState();
}

class _DoDayButtonState extends State<DoDayButton> {
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
            TaskOperations.updateTask(widget.task);
            if (!widget.task.doDay.isAtSameMomentAs(widget.today)) {
              widget.tasks?.remove(widget.task);
            } else if (!(widget.tasks?.contains(widget.task) ?? false)) {
              widget.tasks?.add(widget.task);
            }
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryContainer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: FittedBox(
            child: Header(
          doDay,
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
