import 'package:dis_week/pages/task_view.dart';
import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget createDailyView(BuildContext context, List<Task> taskList) {
  ColorScheme themeColor = Theme.of(context).colorScheme;
  double mqTextScaleFactor = MediaQuery.of(context).textScaleFactor;

  return ListView.separated(
    separatorBuilder: (context, _) => const SizedBox(height: 15),
    itemCount: taskList.length,
    itemBuilder: (BuildContext context, int index) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskView.edit(task: taskList[index])));
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: themeColor.surfaceVariant,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _drawTaskTitle(
                          title: taskList[index].title, themeColor: themeColor),
                      _drawTaskDue(taskList[index].due, themeColor),
                    ],
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: _drawTaskProgress(
                        taskList[index].progress, themeColor)),
              ],
            ),
            _drawTaskTags(
                tags: taskList[index].tags,
                themeColor: themeColor,
                textScaleFactor: mqTextScaleFactor),
          ],
        ),
      );
    },
  );
}

Widget _drawTaskTitle(
    {required String? title, required ColorScheme themeColor}) {
  title = title ?? 'Untitled';

  return Container(
    margin: const EdgeInsets.all(2),
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      color: themeColor.surface,
    ),
    child: Text(title,
        style: TextStyle(
          color: themeColor.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        )),
  );
}

Widget _drawTaskDue(DateTime? taskDue, ColorScheme themeColor) {
  if (taskDue == null) {
    return SizedBox.shrink();
  }
  String monthDay = DateFormat.MMMMd().format(taskDue);

  return Container(
    margin: const EdgeInsets.all(2),
    child: Text("Due $monthDay",
        style: TextStyle(
          color: themeColor.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 19,
        )),
  );
}

Widget _drawTaskProgress(Progress progress, ColorScheme themeColor) {
  return Container(
      margin: const EdgeInsets.all(2),
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
      ));
}

Widget _drawTaskTags(
    {List<String>? tags,
    required ColorScheme themeColor,
    required double textScaleFactor}) {
  if (tags == null) {
    return const SizedBox.shrink();
  }

  return SizedBox(
    height: 28 * textScaleFactor,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      // separatorBuilder: (context, _) => const SizedBox(width: 0),
      itemCount: tags.length,
      itemBuilder: (BuildContext context, int tagIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: themeColor.inversePrimary,
          ),
          child: FittedBox(
              child: Text(
            tags[tagIndex],
            style: TextStyle(
                color: themeColor.onSurface, fontWeight: FontWeight.bold),
          )),
        );
      },
    ),
  );
}
