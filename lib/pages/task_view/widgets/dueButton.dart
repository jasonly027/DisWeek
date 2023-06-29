import 'package:dis_week/utils/Database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/Task.dart';
import 'headerText.dart';

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
                // TaskDatabase.instance.update(widget.task);
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: _containerColor(widget.task.due),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: FittedBox(
                child: headerText(
              text: due,
              textColor: _textColor(widget.task.due),
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
                      // TaskDatabase.instance.update(widget.task);
                    });
                  },
                  icon: const Icon(Icons.close)))
      ],
    );
  }

  Color? _textColor(DateTime? date) {
    ColorScheme theme = Theme.of(context).colorScheme;

    if (date == null ||
        date.difference(DateTime.now()) > const Duration(days: 1)) {
      return theme.onPrimaryContainer;
    }
    return theme.onErrorContainer;
  }

  Color? _containerColor(DateTime? date) {
    ColorScheme theme = Theme.of(context).colorScheme;

    if (date == null ||
        date.difference(DateTime.now()) > const Duration(days: 1)) {
      return theme.primaryContainer;
    }
    return theme.errorContainer;
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
