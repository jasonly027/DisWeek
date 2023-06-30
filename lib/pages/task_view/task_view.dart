import 'package:dis_week/utils/Database.dart';
import 'package:dis_week/utils/Task.dart';
import 'package:flutter/material.dart';
import '../../utils/Tag.dart';
import 'widgets/widgets.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {Key? key,
      required this.task,
      required this.tasks,
      required this.globalTags})
      : title = "New Task",
        super(key: key);

  const TaskView.edit(
      {Key? key,
      required this.task,
      required this.tasks,
      required this.globalTags})
      : title = "Edit Task",
        super(key: key);

  final String title;
  final Task task;
  final List<Task> tasks;
  final List<Tag> globalTags;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Stack(alignment: Alignment.center, children: [
      Scaffold(
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
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              color: theme.onPrimary,
              onPressed: () {
                widget.tasks.remove(widget.task);
                TaskDatabase.instance.deleteTask(widget.task.id!).then((value) {
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
              children: [
                const headerText(text: "Task Name", marginTop: 0),
                TitleField(task: widget.task),
                const headerText(text: "Tags"),
                TagsList(
                    task: widget.task,
                    tasks: widget.tasks,
                    globalTags: widget.globalTags),
                const headerText(text: "Due"),
                DueButton(task: widget.task),
                const headerText(text: "Checklist"),
                Checklist(task: widget.task),
                const headerText(text: "Description"),
                DescriptionField(task: widget.task),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
// List<Tag> globalTags = [
//   Tag(id: 5, color: Colors.red, name: 'urgent'),
//   Tag(id: 4, color: Colors.blue, name: 'animal'),
//   Tag(id: 3, color: Colors.greenAccent, name: 'go home'),
//   Tag(id: 2, color: Colors.indigoAccent, name: 'michael'),
//   Tag(id: 1, color: Colors.lightBlueAccent, name: 'inside outside'),
// ];
}
