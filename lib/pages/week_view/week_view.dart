import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:dis_week/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekView extends StatefulWidget {
  const WeekView({Key? key, required this.today}) : super(key: key);

  final DateTime today;

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = TaskDatabase.instance.readTasksWithinWeekOf(widget.today);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    DateTime startOfWeek = widget.today.subtract(Duration(days: widget.today.weekday % 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    final String weekStr = '${DateFormat.MMMd().format(startOfWeek)} - '
        '${DateFormat.MMMd().format(endOfWeek)}';

    return FutureBuilder(
      future: tasks,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: theme.primaryContainer,
              title: Text(
                weekStr,
                style: TextStyle(
                    color: theme.onPrimaryContainer,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                color: theme.onPrimaryContainer,
                onPressed: () {},
              ),
              actions: <Widget>[
                IconButton(
                    onPressed: () {},
                    color: theme.onPrimaryContainer,
                    icon: const Icon(Icons.calendar_month)),
              ],
            ),
            body: Text('Loading...'),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: theme.primaryContainer,
              title: Text(
                weekStr,
                style: TextStyle(
                    color: theme.onPrimaryContainer,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                color: theme.onPrimaryContainer,
                onPressed: () {},
              ),
              actions: <Widget>[
                IconButton(
                    onPressed: () {},
                    color: theme.onPrimaryContainer,
                    icon: const Icon(Icons.calendar_month)),
              ],
            ),
            body: Container(

            ),
          );
        }
      },
    );
  }
}
