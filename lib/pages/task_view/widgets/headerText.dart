import 'package:flutter/material.dart';

class headerText extends StatelessWidget {
  const headerText({
    super.key,
    required this.text,
    this.fontSize = 23,
    this.marginTop = 12,
    this.textColor
  });

  final String text;
  final double fontSize;
  final double marginTop;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Text(text,
          style: TextStyle(
            color: textColor ?? theme.primary,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            shadows: const [Shadow(blurRadius: 0.5)],
          )),
    );
  }
}
