import 'package:flutter/material.dart';
import 'package:dis_week/utils/database/taskOperations.dart';
import '../../../utils/Task.dart';

class TitleField extends StatelessWidget {
  const TitleField({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return TextFormField(
      initialValue: task.title,
      style: TextStyle(fontSize: 19, color: theme.onPrimaryContainer),
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
        if (task.title!.isEmpty) task.title = null;
        TaskOperations.updateTask(task);
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
