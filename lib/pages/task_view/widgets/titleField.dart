import 'package:flutter/material.dart';

import '../../../utils/task.dart';

class titleField extends StatelessWidget {
  const titleField({
    super.key,
    required this.task,
    required this.theme
  });

  final Task task;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: task.title,
      style: const TextStyle(fontSize: 19),
      decoration: InputDecoration(
          hintText: 'Untitled',
          filled: true,
          fillColor: theme.primaryContainer,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10))),
      onChanged: (text) {
        task.title = text;
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
