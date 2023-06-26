import 'package:flutter/material.dart';

class tagsList extends StatefulWidget {
  const tagsList({
    super.key,
    required this.tags,
  });

  final List<String>? tags;

  @override
  State<tagsList> createState() => _tagsListState();
}

class _tagsListState extends State<tagsList> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Wrap(children: [
        ...?widget.tags
            ?.map((item) => tagButton(
            onPressed: () {
              setState(() {
                widget.tags?.remove(item);
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
