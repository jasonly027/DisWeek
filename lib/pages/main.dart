import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:flutter/material.dart';
import '../config/color_schemes.g.dart';

void main() async {
  runApp(DisWeek());
}

class DisWeek extends StatelessWidget {
  DisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return MaterialApp(
        title: 'DisWeek',
        // theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: DailyView(today: today, pushToWeekView: true,));
  }
}
