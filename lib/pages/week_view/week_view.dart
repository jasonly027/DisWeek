import 'package:dis_week/utils/weekPickerDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/Tag.dart';
import 'widgets/widgets.dart';

class WeekViewScreen extends StatefulWidget {
  WeekViewScreen({Key? key, required this.today, required this.globalTags})
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
  State<WeekViewScreen> createState() => _WeekViewScreenState();
}

class _WeekViewScreenState extends State<WeekViewScreen> {
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
                weekPickerDialog(
                    context: context,
                    today: widget.today,
                    globalTags: widget.globalTags);
              },
              color: theme.onPrimaryContainer,
              icon: const Icon(Icons.calendar_month)),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: WeekViewScreen.weekDays.length,
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
