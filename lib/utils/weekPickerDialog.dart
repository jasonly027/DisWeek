import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import '../screens/week_view/week_view.dart';
import 'Tag.dart';

Future WeekPickerDialog(
    {required BuildContext context,
    required DateTime today,
    required List<Tag> globalTags}) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: WeekPicker(
                selectedDate: today,
                datePickerStyles: DatePickerRangeStyles(
                    currentDateStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer)),
                firstDate: DateTime(1970),
                lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
                onChanged: (DatePeriod week) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeekViewScreen(
                              today: week.start, globalTags: globalTags)),
                      (route) => false);
                },
              ),
            ),
          ));
}
