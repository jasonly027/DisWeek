import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:dis_week/utils/database.dart';
import 'package:flutter/material.dart';

import '../config/color_schemes.g.dart';
import '../utils/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DisWeek(tasks: TaskDatabase.instance.readAll()));
}

class DisWeek extends StatelessWidget {
  const DisWeek({super.key, required this.tasks});

  final Future<List<Task>> tasks;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DisWeek',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        // theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
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
