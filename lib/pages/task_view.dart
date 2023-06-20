import 'package:dis_week/pages/task_view_helper.dart';
import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  TaskView({Key? key, required this.title, required this.task})
      : super(key: key);
  final String title;
  Task task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme themeColor = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor.onBackground,
          title: Text(
            widget.title,
            style: TextStyle(color: themeColor.onPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const BackButtonIcon(),
            color: themeColor.onPrimary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              color: themeColor.onPrimary,
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
                makeHeaderText(
                    text: "Task Name", color: themeColor.primary, marginTop: 0),
                makeTitleField(
                    controller: _nameController, themeColor: themeColor),
                makeHeaderText(text: "Tags", color: themeColor.primary),
                makeTagList(tags: widget.task.tags, themeColor: themeColor),
                makeHeaderText(text: "Due", color: themeColor.primary),
                makeDueButton(widget.task.due, themeColor),
                makeHeaderText(text: "Checklist", color: themeColor.primary),
                //
                makeHeaderText(text: "Description", color: themeColor.primary),
                makeDescriptionField(
                    controller: _descriptionController, themeColor: themeColor),
              ],
            ),
          ),
        ));
  }
}
