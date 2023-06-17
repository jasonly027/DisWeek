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
        backgroundColor: themeColor.onBackground,
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
                      builder: (context) => const TaskView(title: "New Task")));
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
  Task(due: DateTime.now().toLocal(), tags: [
    'urgent',
    'animal',
    'go home',
    'asaaaaaaaaaaaaaaaaaaaaaaaaa',
    'bbbbbbbbbbbbbbb',
    'casdasdasdasdasdasdas',
    'd'
  ]),
  Task(due: DateTime.now().toLocal(), tags: ['late', 'home']),
];
