import 'package:dis_week/pages/daily_view.dart';
import 'package:flutter/material.dart';
import 'package:dis_week/theme/color_schemes.g.dart';

void main() {
  runApp(const DisWeek());
}

class DisWeek extends StatelessWidget {
  const DisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisWeek',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const DailyView(title: 'Today'),
    );
  }
}
