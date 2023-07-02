import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Date extends StatelessWidget {
  const Date(this.date, {Key? key}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    final String dateStr = DateFormat.MMMd().format(date);

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: theme.onSecondaryContainer),
      child: FittedBox(
        child: Text(
          dateStr,
          style: TextStyle(
              color: theme.secondaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
      ),
    );
  }
}
