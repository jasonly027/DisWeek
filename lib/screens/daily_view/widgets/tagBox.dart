import 'package:dis_week/utils/Tag.dart';
import 'package:dis_week/utils/TagHelper.dart';
import 'package:flutter/material.dart';

class TagBox extends StatelessWidget {
  const TagBox({Key? key, required this.tagID, required this.globalTags})
      : super(key: key);

  final int tagID;
  final List<Tag> globalTags;

  @override
  Widget build(BuildContext context) {
    Tag tag = getGlobalTag(tagID, globalTags);

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
            color: tag.color,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Text(
          tag.name ?? "     ",
          style: TextStyle(
              color: tag.color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              fontSize: 16,
              shadows: const [Shadow(blurRadius: 1)],
              fontWeight: FontWeight.bold),
        ));
  }
}
