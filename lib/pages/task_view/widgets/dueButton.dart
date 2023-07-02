import 'package:dis_week/utils/database/taskOperations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/Task.dart';
import 'header.dart';

class DueButton extends StatefulWidget {
  const DueButton({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<DueButton> createState() => _DueButtonState();
}

class _DueButtonState extends State<DueButton> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    String due;
    if (widget.task.due == null) {
      due = "Add a Due Date";
    } else {
      due = DateFormat("MMMM d 'at' h':'mm a").format(widget.task.due!);
    }

    return Row(
      children: [
        Expanded(
          flex: 8,
          child: ElevatedButton(
            onPressed: () async {
              DateTime? tempDate = await _pickDate(widget.task.due);
              if (tempDate == null) return;

              TimeOfDay? tempTime = await _pickTime(widget.task.due);
              if (tempTime == null) return;

              final DateTime tempDateTime = DateTime(tempDate.year,
                  tempDate.month, tempDate.day, tempTime.hour, tempTime.minute);

              setState(() {
                widget.task.due = tempDateTime;
                TaskOperations.updateTask(widget.task);
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Task.isUrgent(widget.task)
                    ? theme.errorContainer
                    : theme.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: FittedBox(
                child: Header(
              due,
              textColor: Task.isUrgent(widget.task)
                  ? theme.onErrorContainer
                  : theme.onPrimaryContainer,
              marginTop: 0,
            )),
          ),
        ),
        if (widget.task.due != null)
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.task.due = null;
                      TaskOperations.updateTask(widget.task);
                    });
                  },
                  icon: const Icon(Icons.close)))
      ],
    );
  }

  Future<DateTime?> _pickDate(DateTime? date) => showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)));

  Future<TimeOfDay?> _pickTime(DateTime? date) {
    return showTimePicker(
      context: context,
      initialTime: (date != null)
          ? TimeOfDay.fromDateTime(date)
          : const TimeOfDay(hour: 23, minute: 59),
    );
  }
}
