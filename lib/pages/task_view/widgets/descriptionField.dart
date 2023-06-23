import 'package:flutter/material.dart';
import '../../../utils/task.dart';

class descriptionField extends StatelessWidget {
  const descriptionField({
    super.key,
    required this.task,
    required this.theme
  });

  final Task task;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
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
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
