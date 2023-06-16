import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


Widget createDailyView(BuildContext context, List<Task> taskList) {
  ColorScheme themeColor = Theme.of(context).colorScheme;
  double mqTextScaleFactor = MediaQuery.of(context).textScaleFactor;

  return ListView.separated(
    separatorBuilder: (context, _) => const SizedBox(height: 10),
    itemCount: taskList.length,
    itemBuilder: (BuildContext context, int index) {
      return ElevatedButton(
        onPressed: () {

        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: themeColor.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
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
                      _drawTaskTitle(taskList[index].task, themeColor, mqTextScaleFactor),
                      _drawTaskDue(taskList[index].due, themeColor, mqTextScaleFactor),
                    ],
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: _drawTaskProgress(taskList[index].progress, themeColor, mqTextScaleFactor)),
              ],
            ),
            _drawTaskTags(taskList[index].tags, themeColor, mqTextScaleFactor),
          ],
        ),
      );
    },
  );
}

Widget _drawTaskTitle(String taskTitle, ColorScheme themeColor, double mqTextScaleFactor) {
  return Container(
    margin: const EdgeInsets.all(2),
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

Widget _drawTaskDue(DateTime? taskDue, ColorScheme themeColor, double mqTextScaleFactor) {
  if (taskDue == null) {return Container();}
  String monthDay = DateFormat.MMMMd().format(taskDue);

  return Container(
    margin: const EdgeInsets.all(2),
    child: Text("Due $monthDay",
        textScaleFactor: mqTextScaleFactor,
        style: TextStyle(
          color: themeColor.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 19,)),

  );
}

Widget _drawTaskProgress(Progress progress, ColorScheme themeColor, double mqTextScaleFactor) {
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
        )
  );
}

Widget _drawTaskTags(List<String> tags, ColorScheme themeColor, double mqTextScaleFactor) {

    return SizedBox(
      height: 28 * mqTextScaleFactor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // separatorBuilder: (context, _) => const SizedBox(width: 0),
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int tagIndex) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: themeColor.inversePrimary,
            ),
            child: FittedBox(
                child: Text(tags[tagIndex],
                  style: TextStyle(
                    color: themeColor.onSurface,
                    fontWeight: FontWeight.bold
                  ),)),
          );
        },
      ),
    );
}