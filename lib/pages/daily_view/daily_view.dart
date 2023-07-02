import 'dart:io';

import 'package:dis_week/pages/task_view/task_view.dart';
import 'package:dis_week/utils/database/Database.dart';
import 'package:dis_week/utils/TagHelper.dart';
import 'package:dis_week/utils/Task.dart';
import 'package:dis_week/utils/database/tagOperations.dart';
import 'package:dis_week/utils/database/taskOperations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/Tag.dart';
import '../week_view/week_view.dart';
import './widgets/widgets.dart';

class DailyView extends StatefulWidget {
  const DailyView({super.key, required this.today, bool? pushToWeekView,
          this.todayStats})
      : pushToWeekView = pushToWeekView ?? false;

  final DateTime today;
  final bool pushToWeekView;
  final ({String? title, DateTime? due, bool isDone})? todayStats;

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  late Future<List<List>> dataFromDB;

  @override
  void initState() {
    super.initState();
    dataFromDB = TaskDatabase.multiRead([
      TaskOperations.readTasksOnDayOf(widget.today),
      TagOperations.readAllGlobalTags()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    final String todayStr = DateFormat.MMMd().format(widget.today);

    return FutureBuilder(
        future: dataFromDB,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: theme.primaryContainer,
                title: Text(todayStr),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  color: theme.onPrimaryContainer,
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WeekView(
                            today: widget.today,
                          )));
                },
                child: const Icon(Icons.flip_camera_android),
              ),
              body: Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primaryContainer,
                strokeWidth: 5,
              )),
            );
          } else {
            List<Task> tasks = snapshot.data[0];
            List<Tag> globalTags = snapshot.data[1];

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: theme.primaryContainer,
                title: Text(
                  todayStr,
                  style: TextStyle(
                      color: theme.onPrimaryContainer,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  color: theme.onPrimaryContainer,
                  onPressed: () {
                    setState(() {
                      // getApplicationDocumentsDirectory().then((value) {
                      //   File(join(value.path, 'DisWeekTasks.db')).delete();
                      // });
                    });
                  },
                ),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {},
                      color: theme.onPrimaryContainer,
                      icon: const Icon(Icons.calendar_month)),
                  IconButton(
                    onPressed: () {
                      TaskOperations.createTask(Task(doDay: widget.today))
                          .then((value) {
                        Task newTask = value;
                        tasks.add(newTask);

                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => TaskView(
                                      task: newTask,
                                      tasks: tasks,
                                      globalTags: globalTags,
                                      today: widget.today,
                                    )))
                            .then((value) {
                          setState(() {});
                        });
                      });
                    },
                    icon: const Icon(Icons.add),
                    color: theme.onPrimaryContainer,
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (widget.pushToWeekView) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                WeekView(today: widget.today)))
                        .then((value) {
                      setState(() {});
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Icon(Icons.flip_camera_android),
              ),
              body: Container(
                margin: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => TaskView.edit(
                                        task: tasks[index],
                                        tasks: tasks,
                                        globalTags: globalTags,
                                        today: widget.today,
                                      )))
                              .then((value) {
                            setState(() {});
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          backgroundColor: theme.surfaceVariant,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TaskTitle(title: tasks[index].title),
                                  if (tasks[index].due != null)
                                    due(task: tasks[index]),
                                  Wrap(
                                    children: [
                                      ...?LocalTag.orderTags(
                                              task: tasks[index],
                                              globalTags: globalTags,
                                              prune: true)
                                          ?.map((tagID) => TagBox(
                                                tagID: tagID,
                                                globalTags: globalTags,
                                              ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: ProgressIndicatorCustom(
                                  task: tasks[index],
                                  tasks: tasks,
                                  tags: globalTags,
                                  today: widget.today,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        });
  }
}
