import 'package:dis_week/pages/task_view/task_view.dart';
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
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    double txtScaleFactor = MediaQuery.of(context).textScaleFactor;
    var tasks = tempList;

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
          onPressed: () {
            setState(() {});
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: theme.onPrimary,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TaskView()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TaskView.edit(task: tasks[index])));
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
                            due(date: tasks[index].due, theme: theme),
                          ],
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: progress_indicator(
                              progress: tasks[index].progress, theme: theme)),
                    ],
                  ),
                  tags_list(
                      tags: tasks[index].tags,
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
}

var tempList = [
  Task(
    title: "Mango",
    due: DateTime(2023, 6, 23, 4, 27),
    tags: [
      'urgent',
      'animal',
      'go home',
      'djflahsdflaaaaaaaa12312312',
      'bbbbbbbbbbbbbbb',
      'casdasdasdasdasdasdas',
      'd'
    ],
    checklist: [
      Check(title: "Hi Joe", isChecked: true),
      Check(title: "Badger")
    ],
    description: "Hello",
  ),
  Task(
      due: DateTime.now().toLocal(),
      tags: ['late', 'home'],
      checklist: <Check>[]),
  Task(tags: ['guy', 'dog'], checklist: <Check>[])
];
