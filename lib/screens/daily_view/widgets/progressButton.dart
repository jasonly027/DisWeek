import 'package:flutter/material.dart';
import '../../task_view/task_view.dart';
import 'package:dis_week/utils/Utils.dart';

class ProgressButton extends StatefulWidget {
  const ProgressButton(
      {super.key, required this.task, required this.tasks, required this.tags, required this.today});

  final Task task;
  final List<Task> tasks;
  final List<Tag> tags;
  final DateTime today;

  @override
  State<ProgressButton> createState() =>
      _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  int calculateCompleted(List<Check> checklist) {
    int count = 0;
    for (Check check in checklist) {
      if (check.isChecked) {
        ++count;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    Color textColor = theme.onSecondary;

    if (widget.task.isDone) {
      return ElevatedButton(
          onPressed: () {
            setState(() {
              widget.task.isDone = false;
              TaskOperations.updateTask(widget.task);
            });
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(23),
              backgroundColor: theme.tertiary),
          child: Icon(
            Icons.check,
            size: 40,
            color: theme.onTertiary,
          ));
    } else {
      if (widget.task.checklist == null) {
        return ElevatedButton(
            onPressed: () {
              setState(() {
                widget.task.isDone = true;
                TaskOperations.updateTask(widget.task);
              });
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(23),
                backgroundColor: Task.isUrgent(widget.task)
                    ? Theme.of(context).brightness == Brightness.light
                        ? theme.error
                        : theme.errorContainer
                    : theme.surface),
            child: Icon(
              Icons.close,
              size: 40,
              color: Task.isUrgent(widget.task)
                ? Theme.of(context).brightness == Brightness.light
                    ? theme.onError
                    : theme.onErrorContainer
                : theme.onSurface,
            ));
      } else {
        return ElevatedButton(
          onPressed: () {
            if (calculateCompleted(widget.task.checklist!) ==
                widget.task.checklist!.length) {
              setState(() {
                widget.task.isDone = true;
                TaskOperations.updateTask(widget.task);
              });
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => TaskViewScreen.edit(
                            task: widget.task,
                            tasks: widget.tasks,
                            globalTags: widget.tags,
                            today: widget.today,
                          )))
                  .then((value) {
                setState(() {});
              });
            }
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: theme.secondary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                calculateCompleted(widget.task.checklist!).toString(),
                style: TextStyle(color: textColor, fontSize: 20),
              ),
              Divider(
                color: textColor,
                height: 3,
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
              ),
              Text(
                widget.task.checklist!.length.toString(),
                style: TextStyle(color: textColor, fontSize: 20),
              ),
            ],
          ),
        );
      }
    }
  }
}
