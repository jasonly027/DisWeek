import 'package:dis_week/pages/task_view/task_view.dart';
import 'package:dis_week/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/weekPickerDialog.dart';
import '../week_view/week_view.dart';
import './widgets/widgets.dart';

class DailyViewScreen extends StatefulWidget {
  const DailyViewScreen({super.key, required this.today, bool? pushToWeekView})
      : pushToWeekView = pushToWeekView ?? false;

  final DateTime today;
  final bool pushToWeekView;

  @override
  State<DailyViewScreen> createState() => _DailyViewScreenState();
}

class _DailyViewScreenState extends State<DailyViewScreen> {
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
                    onPressed: () {
                      WeekPickerDialog(
                          context: context,
                          today: widget.today,
                          globalTags: globalTags);
                    },
                    color: theme.onPrimaryContainer,
                    icon: const Icon(Icons.calendar_month)),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      TaskOperations.createTask(Task(doDay: widget.today))
                          .then((value) {
                        Task newTask = value;
                        tasks.add(newTask);

                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => TaskViewScreen.create(
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
                            builder: (context) => WeekViewScreen(
                                today: widget.today, globalTags: globalTags)))
                        .then((value) {
                      setState(() {
                        dataFromDB = TaskDatabase.multiRead([
                          TaskOperations.readTasksOnDayOf(widget.today),
                          TagOperations.readAllGlobalTags()
                        ]);
                      });
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Icon(Icons.flip_camera_android),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => TaskViewScreen.edit(
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
                                    Due(task: tasks[index]),
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
                                child: ProgressButton(
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
