import 'package:dis_week/pages/daily_view_helper.dart';
import 'package:dis_week/pages/task_view.dart';
import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';

class DailyView extends StatefulWidget {
  const DailyView({super.key, required this.title});
  final String title;

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme themeColor = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: themeColor.primary,
        title: Text(
          widget.title,
          style: TextStyle(color: themeColor.onPrimary),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: themeColor.onPrimary,
          onPressed: () {
            setState(() {
              print("setStating");
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: themeColor.onPrimary,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TaskView()));
            },
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: createDailyView(context, tempList),
      ),
    );
  }
}

var tempList = [
  Task(
    title: "Mango",
    due: DateTime.now().toLocal(),
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
  Task(due: DateTime.now().toLocal(), tags: ['late', 'home']),
  Task(tags: ['guy', 'dog'])
];
