import 'package:flutter/material.dart';
import 'package:dis_week/utils/Task.dart';
import '../../utils/Tag.dart';
import 'package:dis_week/utils/database/taskOperations.dart';
import 'widgets/widgets.dart';

class TaskViewScreen extends StatefulWidget {
  const TaskViewScreen.create(
      {Key? key,
      required this.task,
      required this.tasks,
      required this.globalTags,
      required this.today})
      : title = "New Task",
        super(key: key);

  const TaskViewScreen.edit(
      {Key? key,
      required this.task,
      required this.tasks,
      required this.globalTags,
      required this.today})
      : title = "Edit Task",
        super(key: key);

  final String title;
  final Task task;
  final List<Task>? tasks;
  final List<Tag> globalTags;
  final DateTime today;

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Stack(alignment: Alignment.center, children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryContainer,
          title: Text(
            widget.title,
            style: TextStyle(
                color: theme.onPrimaryContainer, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const BackButtonIcon(),
            color: theme.onPrimaryContainer,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              color: theme.onPrimaryContainer,
              onPressed: () {
                widget.tasks?.remove(widget.task);
                TaskOperations.deleteTask(widget.task.id!).then((value) {
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Header("Task Name", marginTop: 0),
                TitleField(task: widget.task),
                const Header("Tags"),
                TagsList(task: widget.task, globalTags: widget.globalTags),
                const Header("Doing On"),
                DoDayButton(
                    task: widget.task,
                    tasks: widget.tasks,
                    today: widget.today),
                const Header("Due"),
                DueButton(task: widget.task),
                const Header("Checklist"),
                Checklist(task: widget.task),
                const Header("Description"),
                DescriptionField(task: widget.task),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
