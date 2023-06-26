import 'package:flutter/material.dart';

class tags_list extends StatelessWidget {
  const tags_list(
      {super.key,
      required this.tags,
      required this.theme,
      required this.txtScaleFactor});

  final List<String> tags;
  final ColorScheme theme;
  final double txtScaleFactor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28 * txtScaleFactor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // separatorBuilder: (context, _) => const SizedBox(width: 0),
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int tagIndex) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: theme.inversePrimary,
            ),
            child: FittedBox(
                child: Text(
              tags[tagIndex],
              style: TextStyle(
                  color: theme.onSurface, fontWeight: FontWeight.bold),
            )),
          );
        },
      ),
    );
  }
}
