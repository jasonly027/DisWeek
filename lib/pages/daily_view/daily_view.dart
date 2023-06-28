import 'package:dis_week/pages/task_view/task_view.dart';
import 'package:dis_week/utils/database.dart';
import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';
import './widgets/widgets.dart';

class DailyView extends StatefulWidget {
  const DailyView({super.key, required this.title});

  final String title;

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  List<Task> tasks = [];

  _DailyViewState() {
    refreshTaskDatabase();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    double txtScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.primary,
        title: Text(
          widget.title,
          style: TextStyle(color: theme.onPrimary),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: theme.onPrimary,
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: theme.onPrimary,
            onPressed: () {
              TaskDatabase.instance
                  .create(Task(doDay: DateTime.now()))
                  .then((value) {
                Task newTask = value;
                tasks.add(newTask);

                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => TaskView(
                              task: newTask,
                              tasks: tasks,
                            )))
                    .then((value) {
                  setState(() {});
                });
              });
            },
          )
        ],
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
                            task_title(title: tasks[index].title, theme: theme),
                            if (tasks[index].due != null)
                              due(date: tasks[index].due!, theme: theme),
                          ],
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: progress_indicator(
                              progress: tasks[index].progress, theme: theme)),
                    ],
                  ),
                  if (tasks[index].tags?.isNotEmpty ?? false)
                    tags_list(
                        tags: tasks[index].tags!,
                        theme: theme,
                        txtScaleFactor: txtScaleFactor),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> refreshTaskDatabase() async {
    TaskDatabase.instance.readAll().then((list) {
      tasks = list;
      print("Done Loading");
    }).onError((error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
    });
  }
}

var tempList = [
  Task(
    title: "Mango",
    doDay: DateTime.now(),
    due: DateTime(2023, 6, 23, 4, 27),
    tags: [
      'urgent',
      'animal',
      'go home',
    ],
    checklist: [
      Check(title: "Hi Joe", isChecked: true),
      Check(title: "Badger")
    ],
    description: "Hello",
  ),
  Task(
    doDay: DateTime.now(),
    due: DateTime.now().toLocal(),
    tags: ['late', 'home'],
  ),
  Task(title: "aloha", doDay: DateTime.now(), tags: ['guy', 'dog']),
];
