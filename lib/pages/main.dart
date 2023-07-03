import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:flutter/material.dart';
import '../config/color_schemes.g.dart';

void main() async {
  runApp(const DisWeek());
}

class DisWeek extends StatelessWidget {
  const DisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return MaterialApp(
        title: 'DisWeek',
        themeMode: ThemeMode.system,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: DailyViewScreen(
          today: today,
          pushToWeekView: true,
        ));
  }
}
