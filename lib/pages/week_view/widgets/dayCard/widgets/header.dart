import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: theme.primary),
      child: FittedBox(
        child: Text(
          text,
          style: TextStyle(
              color: theme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
      ),
    );
  }
}
