import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:dis_week/utils/Database.dart';
import 'package:flutter/material.dart';
import '../config/color_schemes.g.dart';
import '../utils/Tag.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(DisWeek());
}

class DisWeek extends StatelessWidget {
  DisWeek({super.key});

  final Future<List<Tag>> globalTags = TaskDatabase.instance.readAllGlobalTags();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return MaterialApp(
        title: 'DisWeek',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        // theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: FutureBuilder(
          future: globalTags,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return DailyView(
                globalTags: snapshot.data,
                today: today,
              );
            } else {
              return DailyView(
                globalTags: const [],
                today: today,
              );
            }
          },
        ));
  }
}
