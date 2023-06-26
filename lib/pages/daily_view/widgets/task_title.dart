import 'package:flutter/material.dart';

class task_title extends StatelessWidget {
  final String? title;
  final ColorScheme theme;

  const task_title({
    super.key,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
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
            fontSize: 22,
          )),
    );
  }
}
