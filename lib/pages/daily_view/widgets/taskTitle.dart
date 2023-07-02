import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  final String? title;

  const TaskTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: theme.surface,
      ),
      child: Text(title ?? 'Untitled',
          style: TextStyle(
            color: theme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          )),
    );
  }
}
