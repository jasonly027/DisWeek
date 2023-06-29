import 'package:dis_week/utils/Database.dart';
import 'package:dis_week/utils/Task.dart';
import 'package:flutter/material.dart';
import '../../utils/Tag.dart';
import 'widgets/widgets.dart';

class TaskView extends StatefulWidget {
  const TaskView({Key? key, required this.task, required this.tasks})
      : title = "New Task",
        super(key: key);

  const TaskView.edit({Key? key, required this.task, required this.tasks})
      : title = "Edit Task",
        super(key: key);

  final String title;
  final Task task;
  final List<Task> tasks;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  bool showTagsMenu = false;

  void showTagsMenuFunc(bool value) {
    setState(() {
      showTagsMenu = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    ValueNotifier<Task> task = ValueNotifier(widget.task);

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
                // widget.tasks.remove(widget.task);
                // TaskDatabase.instance.delete(widget.task.id!).then((value) {
                //   Navigator.pop(context);
                // });
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
                TagsList(toggle: showTagsMenuFunc, task: widget.task),
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
      if (showTagsMenu)
        TagsMenu(
            task: widget.task,
            tasks: widget.tasks,
            globalTags: globalTags,
            toggle: showTagsMenuFunc),
    ]);
  }
}

List<Tag> globalTags = [
  Tag(color: Colors.red, name: 'urgent'),
  Tag(color: Colors.blue, name: 'animal'),
  Tag(color: Colors.greenAccent, name: 'go home'),
  Tag(color: Colors.indigoAccent, name: 'michael'),
  Tag(color: Colors.lightBlueAccent, name: 'inside outside'),
];
