import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Progress { incomplete, complete, checklist }

class Task {
  String task;
  DateTime? due;
  List<String> tags;
  Progress progress;

  Task(
      {this.task = 'The quick brown fox jumped over the lazy dog',
      this.due,
      required this.tags,
      this.progress = Progress.incomplete});
}

ListView createDailyView(BuildContext context, List<Task> taskList) {
  ColorScheme themeColor = Theme.of(context).colorScheme;
  double mqTextScaleFactor = MediaQuery.of(context).textScaleFactor;

  return (ListView.separated(
    separatorBuilder: (context, _) => const SizedBox(height: 10),
    itemCount: taskList.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // border: Border.all(color: themeColor.shadow),
          borderRadius: BorderRadius.circular(15),
          color: themeColor.surfaceVariant,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _makeTaskTitle(taskList[index].task, themeColor, mqTextScaleFactor),
                      _makeTaskDue(taskList[index].due, themeColor, mqTextScaleFactor),
                    ],
                  ),
                ),
                const Spacer(),
                Flexible(
                    flex: 2,
                    child: _makeTaskProgress(taskList[index].progress, themeColor, mqTextScaleFactor)),
              ],
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, _) => const SizedBox(width: 10),
                itemCount: taskList[index].tags.length,
                itemBuilder: (BuildContext context2, int tagIndex) {
                  return Text(taskList[index].tags[tagIndex]);
                },
              ),
            )
          ],
        ),
      );
    },
  ));
}

Widget _makeTaskTitle(String taskTitle, ColorScheme themeColor, double mqTextScaleFactor) {
  return Container(
    margin: const EdgeInsets.all(3),
    padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      color: themeColor.surface,
    ),
    child: Text(taskTitle,
        textScaleFactor: mqTextScaleFactor,
        style: TextStyle(
            color: themeColor.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 22,)),
  );
}

Widget _makeTaskDue(DateTime? taskDue, ColorScheme themeColor, double mqTextScaleFactor) {
  if (taskDue == null) {return Container();}
  String monthDay = DateFormat.MMMMd().format(taskDue);

  return Container(
    margin: const EdgeInsets.all(3),
    child: Text("Due $monthDay",
        textScaleFactor: mqTextScaleFactor,
        style: TextStyle(
          color: themeColor.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 19,)),

  );
}

Widget _makeTaskProgress(Progress progress, ColorScheme themeColor, double mqTextScaleFactor) {
  return Container(
    margin: const EdgeInsets.all(3),
    child: IconButton.filled(
          color: themeColor.onTertiary,
          icon: const Icon(Icons.check),
          iconSize: 25,
          onPressed: () {
            switch (progress) {
              case Progress.checklist:
                //
              case Progress.incomplete:
                //
              case Progress.complete:
                //
            }
          },
        )
  );
}
