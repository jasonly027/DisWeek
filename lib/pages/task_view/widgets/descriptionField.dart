import 'package:flutter/material.dart';
import '../../../utils/database.dart';
import '../../../utils/task.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return TextFormField(
      initialValue: task.description,
      maxLines: null,
      decoration: InputDecoration(
          hintText: 'Add a description',
          filled: true,
          fillColor: theme.primaryContainer,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10))),
      onChanged: (text) {
        task.description = text;
        if (task.description!.isEmpty) task.description = null;
        TaskDatabase.instance.update(task);
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
