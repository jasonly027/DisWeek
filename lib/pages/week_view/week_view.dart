import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:dis_week/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/widgets.dart';

class WeekView extends StatefulWidget {
  WeekView({Key? key, required this.today})
      : startOfWeek = today.subtract(Duration(days: today.weekday % 7)),
        endOfWeek = today
            .subtract(Duration(days: today.weekday % 7))
            .add(const Duration(days: 6)),
        super(key: key);

  final DateTime today;
  final DateTime startOfWeek;
  final DateTime endOfWeek;

  static const List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  late Future<List<List<({String? title, DateTime? due})>>> days;

  @override
  void initState() {
    super.initState();
    days = _readTasksWithinWeek();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    final String weekStr = '${DateFormat.MMMd().format(widget.startOfWeek)} - '
        '${DateFormat.MMMd().format(widget.endOfWeek)}';

    return FutureBuilder(
        future: days,
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
              body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: WeekView.weekDays.length,
                  itemBuilder: (context, currentDay) {
                    DateTime currentDateTime =
                    widget.startOfWeek.add(Duration(days: currentDay));
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context) =>
                                  DailyView(today: currentDateTime)))
                              .then((value) {
                            setState(() {
                              days = _readTasksWithinWeek();
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          backgroundColor: theme.surfaceVariant,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Flexible(
                              flex: 6,
                              child: Tasks(),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Header(WeekView.weekDays[currentDay]),
                                  const Add(),
                                  Date(currentDateTime)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            List<List<({String? title, DateTime? due})>> titlesAndDues =
                snapshot.data;

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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: titlesAndDues.length,
                  itemBuilder: (context, currentDay) {
                    DateTime currentDateTime =
                        widget.startOfWeek.add(Duration(days: currentDay));
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      DailyView(today: currentDateTime)))
                              .then((value) {
                            setState(() {
                              days = _readTasksWithinWeek();
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          backgroundColor: theme.surfaceVariant,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Tasks(
                                titlesAndDues: titlesAndDues[currentDay],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Header(WeekView.weekDays[currentDay]),
                                  const Add(),
                                  Date(currentDateTime)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        });
  }

  Future<List<({String? title, DateTime? due})>> _readTaskTitlesAndDuesFromDay(
      int offset) {
    return TaskOperations.readTaskTitlesAndDuesOnDayOf(
        widget.startOfWeek.add(Duration(days: offset)));
  }

  Future<List<List<({String? title, DateTime? due})>>>
      _readTasksWithinWeek() async {
    return [
      await _readTaskTitlesAndDuesFromDay(0),
      await _readTaskTitlesAndDuesFromDay(1),
      await _readTaskTitlesAndDuesFromDay(2),
      await _readTaskTitlesAndDuesFromDay(3),
      await _readTaskTitlesAndDuesFromDay(4),
      await _readTaskTitlesAndDuesFromDay(5),
      await _readTaskTitlesAndDuesFromDay(6),
    ];
  }
}
