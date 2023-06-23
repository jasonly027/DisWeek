import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:flutter/material.dart';

import '../config/color_schemes.g.dart';

void main() {
  runApp(const DisWeek());
}

class DisWeek extends StatelessWidget {
  const DisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisWeek',
      // theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const DailyView(title: 'Today'),
    );
  }
}
