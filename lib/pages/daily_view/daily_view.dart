import 'dart:io';

import 'package:dis_week/pages/task_view/task_view.dart';
import 'package:dis_week/utils/Database.dart';
import 'package:dis_week/utils/TagHelper.dart';
import 'package:dis_week/utils/Task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/Tag.dart';
import '../week_view/week_view.dart';
import './widgets/widgets.dart';

class DailyView extends StatefulWidget {
  const DailyView({super.key, required this.globalTags, required this.today});

  final List<Tag> globalTags;
  final DateTime today;

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = TaskDatabase.instance.readTasksOnDayOf(widget.today);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    final String todayStr = DateFormat.MMMd().format(widget.today);

    return FutureBuilder(
        future: tasks,
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
              body: Text('Loading'),
            );
          } else {
            List<Task> tasks = snapshot.data;

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
                      TaskDatabase.instance
                          .createTask(Task(doDay: DateTime.now()))
                          .then((value) {
                        Task newTask = value;
                        tasks.add(newTask);

                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => TaskView(
                                      task: newTask,
                                      tasks: tasks,
                                      globalTags: widget.globalTags,
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WeekView(today: widget.today)));
                },
                child: const Icon(Icons.flip_camera_android),
              ),
              body: Container(
                margin: const EdgeInsets.all(20),
                child: ListView.separated(
                  separatorBuilder: (context, _) => const SizedBox(height: 15),
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => TaskView.edit(
                                      task: tasks[index],
                                      tasks: tasks,
                                      globalTags: widget.globalTags,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TaskTitle(
                                    title: tasks[index].title, theme: theme),
                                if (tasks[index].due != null)
                                  due(date: tasks[index].due!, theme: theme),
                                Wrap(
                                  children: [
                                    ...?LocalTag.orderTags(
                                            task: tasks[index],
                                            globalTags: widget.globalTags,
                                            prune: true)
                                        ?.map((tagID) => TagBox(
                                              tagID: tagID,
                                              globalTags: widget.globalTags,
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
                                tags: widget.globalTags,
                                today: widget.today,
                              )),
                        ],
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
