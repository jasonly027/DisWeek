import 'package:dis_week/pages/task_view_helper.dart';
import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  const TaskView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final _titleController = TextEditingController(text: 'Untitled');
  // Task task = Task(task: _titleController.toString(), )

  @override
  Widget build(BuildContext context) {
    ColorScheme themeColor = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.onBackground,
        title: Text(widget.title,
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
            onPressed: () {

            },
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title",
              style: headerFontStyle(color: themeColor.primary)),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Untitled',
                filled: true,
                fillColor: themeColor.primaryContainer,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)
                )
              )
            ),
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ,
            )
          ],
        ),
      )
    );
  }
}
