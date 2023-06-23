import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'headerText.dart';

class dueButton extends StatelessWidget {
  const dueButton({
    super.key,
    required this.date,
  });

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    String due;
    if (date == null) {
      due = "Add a Due Date";
    } else {
      due = DateFormat("MMMM d 'at' h':'mm a").format(date!);
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: headerText(
              text: due, marginTop: 0)),
    );
  }
}
