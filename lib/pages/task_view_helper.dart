import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget makeHeaderText(
        {required String text,
        required Color color,
        double fontSize = 23,
        double marginTop = 12}) =>
    Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Text(text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          )),
    );

Widget makeTitleField(
        {required TextEditingController controller,
        required ColorScheme themeColor}) =>
    TextField(
      controller: controller,
      style: const TextStyle(fontSize: 19),
      decoration: InputDecoration(
          hintText: 'Untitled',
          filled: true,
          fillColor: themeColor.primaryContainer,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10))),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );

Widget makeTagList(
        {required List<String> tags, required ColorScheme themeColor}) =>
    Wrap(children: [
      ...tags
          .map((item) => _makeTagButton(
              onPressed: () {},
              textColor: themeColor.onSurface,
              backgroundColor: themeColor.inversePrimary,
              tagName: item))
          .toList(),
      _makeTagButton(
          onPressed: () {},
          textColor: themeColor.onSurface,
          backgroundColor: themeColor.tertiaryContainer,
          tagName: "Add Tag")
    ]);

Widget _makeTagButton({
  required void Function()? onPressed,
  required Color? textColor,
  required Color? backgroundColor,
  required String tagName,
}) =>
    Padding(
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
          child: Text(tagName,
              style: TextStyle(
                  color: textColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold))),
    );

Widget makeDueButton(DateTime? date, ColorScheme themeColor) {
  String due;
  if (date == null) {
    due = "Add a Due Date";
  } else {
    due = DateFormat("MMMM d 'at' h':'m a").format(date);
  }

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: themeColor.primaryContainer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: makeHeaderText(
            text: due, color: themeColor.onPrimaryContainer, marginTop: 0)),
  );
}

Widget makeDescriptionField(
        {required TextEditingController controller,
        required ColorScheme themeColor}) =>
    TextField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
          hintText: 'Add a description',
          filled: true,
          fillColor: themeColor.primaryContainer,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10))),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
