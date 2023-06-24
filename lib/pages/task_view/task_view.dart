import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class TaskView extends StatefulWidget {
  TaskView({Key? key})
      : title = "New Task",
        task = Task(checklist: <Check>[]),
        super(key: key);

  const TaskView.edit({Key? key, required this.task})
      : title = "Edit Task",
        super(key: key);

  final String title;
  final Task task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primary,
          title: Text(
            widget.title,
            style: TextStyle(color: theme.onPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const BackButtonIcon(),
            color: theme.onPrimary,
            onPressed: () {
              Navigator.pop(context);
              print(widget.task.due);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              color: theme.onPrimary,
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const headerText(text: "Task Name", marginTop: 0),
                titleField(task: widget.task),
                const headerText(text: "Tags"),
                tagsList(tags: widget.task.tags),
                const headerText(text: "Due"),
                dueButton(task: widget.task),
                const headerText(text: "Checklist"),
                checklist(checks: widget.task.checklist),
                const headerText(text: "Description"),
                descriptionField(task: widget.task),
              ],
            ),
          ),
        ));
  }
}
