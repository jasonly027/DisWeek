import 'package:dis_week/pages/daily_view/daily_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import '../../utils/Tag.dart';
import 'widgets/widgets.dart';

class WeekView extends StatefulWidget {
  WeekView({Key? key, required this.today, required this.globalTags})
      : startOfWeek = today.subtract(Duration(days: today.weekday % 7)),
        endOfWeek = today
            .subtract(Duration(days: today.weekday % 7))
            .add(const Duration(days: 6)),
        super(key: key);

  final List<Tag> globalTags;
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
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    final String weekStr = '${DateFormat.MMMd().format(widget.startOfWeek)} - '
        '${DateFormat.MMMd().format(widget.endOfWeek)}';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.primaryContainer,
        title: Text(
          weekStr,
          style: TextStyle(
              color: theme.onPrimaryContainer, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: theme.onPrimaryContainer,
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) =>
                // ));
                //
              },
              color: theme.onPrimaryContainer,
              icon: const Icon(Icons.calendar_month)),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: WeekView.weekDays.length,
          itemBuilder: (context, currentDay) {
            DateTime currentDateTime =
                widget.startOfWeek.add(Duration(days: currentDay));
            return DayCard(
              currentDay: currentDay,
              currentDateTime: currentDateTime,
              globalTags: widget.globalTags,
            );
          },
        ),
      ),
    );
  }
}
