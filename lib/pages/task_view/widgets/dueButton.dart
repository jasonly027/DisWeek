import 'package:dis_week/utils/Notifications.dart';
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
  void initState() {
    super.initState();
    NotificationsHelper.init(initScheduled: true);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    String initialNotifyString;
    if (widget.task.due == null || widget.task.notify == null) {
      initialNotifyString = Task.notifyOptions[0].string;
    } else {
      initialNotifyString = Task.notifyOptions
          .firstWhere((option) =>
              option.duration ==
              widget.task.due!.difference(widget.task.notify!))
          .string;
    }

    String due;
    if (widget.task.due == null) {
      due = "Add a Due Date";
    } else {
      due = DateFormat("MMM d 'at' h':'mm a").format(widget.task.due!);
    }

    return Row(
      children: [
        if (widget.task.due != null)
          Expanded(
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                          builder: (builder, dialogState) => AlertDialog(
                            title: const Center(
                                child: Text(
                              'Notification Reminder',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: initialNotifyString,
                                    isExpanded: true,
                                    items: Task.notifyOptions
                                        .map((option) =>
                                            buildMenuItem(option.string))
                                        .toList(),
                                    onChanged: (option) {
                                      dialogState(() {
                                        initialNotifyString = option!;
                                        if (option ==
                                            Task.notifyOptions[0].string) {
                                          widget.task.notify = null;
                                        } else {
                                          widget.task.notify = widget.task.due!
                                              .subtract(Task.notifyOptions
                                                  .firstWhere((option) =>
                                                      option.string ==
                                                      initialNotifyString)
                                                  .duration!);
                                        }
                                        setState(() {
                                          TaskOperations
                                              .updateTaskAndNotification(
                                                  widget.task);
                                        });
                                      });
                                    },
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                      '* Enabling notifications for this app in system settings required',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ));
              },
              icon: Icon(
                Icons.notifications,
                color: widget.task.notify == null
                    ? null
                    : theme.onTertiaryContainer,
              ),
            ),
          ),
        Expanded(
          flex: 7,
          child: ElevatedButton(
            onPressed: () async {
              DateTime? tempDate = await _pickDate(widget.task.due);
              if (tempDate == null) return;

              TimeOfDay? tempTime = await _pickTime(widget.task.due);
              if (tempTime == null) return;

              final DateTime tempDateTime = DateTime(tempDate.year,
                  tempDate.month, tempDate.day, tempTime.hour, tempTime.minute);

              setState(() {
                if (widget.task.notify != null) {
                  Duration difference =
                      widget.task.due!.difference(widget.task.notify!);
                  widget.task.notify = tempDateTime.subtract(difference);
                }

                widget.task.due = tempDateTime;
                TaskOperations.updateTaskAndNotification(widget.task);
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
                      widget.task.notify = null;
                      TaskOperations.updateTaskAndNotification(widget.task);
                    });
                  },
                  icon: const Icon(Icons.close)))
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Center(
          child: Text(
            item,
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
      );

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
