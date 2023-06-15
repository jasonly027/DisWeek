import 'package:flutter/material.dart';

enum Progress { incomplete, complete, checklist }

class Task {
  String task;
  DateTime due;
  List<String> tags;
  Progress progress;

  Task(
      {this.task = 'Untitled',
      required this.due,
      required this.tags,
      this.progress = Progress.incomplete});
}

ListView createDailyView(BuildContext context, List<Task> taskList) {
  ColorScheme themeColor = Theme.of(context).colorScheme;
  double mqTextScaleFactor = MediaQuery.of(context).textScaleFactor;

  return (ListView.builder(
    itemCount: taskList.length,
    itemBuilder: (BuildContext context, int index) {
      return Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  _makeTaskTitle(taskList[index].task, themeColor, mqTextScaleFactor),
                  Text(taskList[index].due.toLocal().toString()),
                ],
              ),
              Text(taskList[index].progress.toString()),
            ],
          ),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, _) => const SizedBox(width: 10),
              itemCount: taskList[index].tags.length,
              itemBuilder: (BuildContext context2, int tagIndex) {
                return Text(taskList[index].tags[tagIndex]);
              },
            ),
          )
        ],
      );
    },
  ));
}

Container _makeTaskTitle(String taskTitle, ColorScheme themeColor, double mqTextScaleFactor) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      color: themeColor.primary,
    ),
    padding: const EdgeInsets.all(4),
    child: Text(taskTitle,
        textScaleFactor: mqTextScaleFactor,
        style: TextStyle(
            color: themeColor.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20)),
  );
}