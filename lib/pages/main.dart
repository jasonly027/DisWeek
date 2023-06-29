import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:dis_week/utils/Database.dart';
import 'package:flutter/material.dart';

import '../config/color_schemes.g.dart';
import '../utils/Check.dart';
import '../utils/Tag.dart';
import '../utils/Task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp(DisWeek(tasks: TaskDatabase.instance.readAll()));

  List<Task> tempList = [
    Task(
      title: "Mango",
      doDay: DateTime.now(),
      due: DateTime(2023, 6, 23, 4, 27),
      tags: [
        Tag(color: Colors.red, name: 'urgent'),
        Tag(color: Colors.blue, name: 'animal'),
        Tag(color: Colors.greenAccent, name: 'go home'),
      ],
      checklist: [
        Check(title: "Hi Joe", isChecked: true),
        Check(title: "Badger")
      ],
      description: "Hello",
    ),
    Task(doDay: DateTime.now(), due: DateTime.now().toLocal(), tags: [
      Tag(color: Colors.indigoAccent, name: 'urgent'),
      Tag(color: Colors.lightBlueAccent, name: 'urgent'),
    ]),
    Task(title: "aloha", doDay: DateTime.now()),
  ];
  runApp(DisWeek(tasks: Future<List<Task>>.value(tempList)));
}

class DisWeek extends StatelessWidget {
  const DisWeek({super.key, required this.tasks});

  final Future<List<Task>> tasks;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DisWeek',
        // theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: FutureBuilder(
          future: tasks,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const DailyView(title: 'Today', tasks: []);
            } else {
              return DailyView(title: 'Today', tasks: snapshot.data);
            }
          },
        ));
  }
}
