import 'package:flutter/material.dart';

import '../../../utils/Tag.dart';

class tags_list extends StatelessWidget {
  const tags_list(
      {super.key,
      required this.tags,
      required this.theme,
      required this.txtScaleFactor});

  final List<Tag> tags;
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
              color: tags[tagIndex].color,
            ),
            child: FittedBox(
                child: Text(
              tags[tagIndex].name ?? "No Name",
              style: TextStyle(
                  color: tags[tagIndex].color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          );
        },
      ),
    );
  }
}
