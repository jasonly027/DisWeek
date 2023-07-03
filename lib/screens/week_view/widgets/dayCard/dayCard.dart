import 'package:flutter/material.dart';
import '../../../../utils/Tag.dart';
import '../../../daily_view/daily_view.dart';
import '../../week_view.dart';
import 'widgets/widgets.dart';

class DayCard extends StatefulWidget {
  const DayCard(
      {Key? key,
      required this.currentDay,
      required this.currentDateTime,
      required this.globalTags})
      : super(key: key);

  final int currentDay;
  final DateTime currentDateTime;
  final List<Tag> globalTags;

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      DailyViewScreen(today: widget.currentDateTime)))
              .then((value) {
            setState(() {
              Scrollable.ensureVisible(context, alignment: 0.5);
            });
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: theme.surfaceVariant,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 6,
              child: TaskTitleList(widget.currentDateTime),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Header(WeekViewScreen.weekDays[widget.currentDay]),
                  AddButton(
                    currentDateTime: widget.currentDateTime,
                    globalTags: widget.globalTags,
                    rebuildDayCard: rebuildDayCard,
                  ),
                  DateText(widget.currentDateTime)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void rebuildDayCard() {
    setState(() {});
  }
}
