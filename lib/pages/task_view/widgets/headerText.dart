import 'package:flutter/material.dart';

class headerText extends StatelessWidget {
  const headerText({
    super.key,
    required this.text,
    this.fontSize = 23,
    this.marginTop = 12
  });

  final String text;
  final double fontSize;
  final double marginTop;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Text(text,
          style: TextStyle(
            color: theme.primary,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          )),
    );
  }
}
