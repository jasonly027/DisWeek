import 'package:dis_week/utils/database.dart';
import 'package:flutter/material.dart';

import '../../../utils/task.dart';

class TagsList extends StatefulWidget {
  const TagsList({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TagsList> createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Wrap(children: [
        ...?widget.task.tags
            ?.map((item) => tagButton(
            onPressed: () {
              setState(() {
                widget.task.tags?.remove(item);
                TaskDatabase.instance.update(widget.task);
              });
            },
            textColor: theme.onSurface,
            backgroundColor: theme.inversePrimary,
            title: item))
            .toList(),
        tagButton(
            onPressed: () {

            },
            textColor: theme.onSurface,
            backgroundColor: theme.tertiaryContainer,
            title: "Add Tag")
      ]);
  }
}

class tagButton extends StatelessWidget {
  const tagButton({
    super.key,
    required this.onPressed,
    required this.textColor,
    required this.backgroundColor,
    required this.title,
  });

  final Function()? onPressed;
  final Color textColor;
  final Color backgroundColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: Text(title!,
              style: TextStyle(
                  color: textColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold))),
    );
  }
}
