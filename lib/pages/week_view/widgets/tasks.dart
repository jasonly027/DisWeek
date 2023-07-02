import 'package:flutter/material.dart';

class Tasks extends StatelessWidget {
  const Tasks({Key? key, this.titlesAndDues}) : super(key: key);

  final List<({String? title, DateTime? due})>? titlesAndDues;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    final scrollController = ScrollController();

    if (titlesAndDues == null) {
      return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          height: 175,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: theme.secondary));
    }

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      height: 175,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: theme.secondary),
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: scrollController,
          itemCount: titlesAndDues!.length,
          itemBuilder: (context, taskIndex) {
            return Text(
              titlesAndDues![taskIndex].title ?? 'Untitled',
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: _textColor(
                      due: titlesAndDues![taskIndex].due, theme: theme)),
            );
          },
        ),
      ),
    );
  }

  Color _textColor({required DateTime? due, required ColorScheme theme}) {
    if (due == null ||
        due.difference(DateTime.now()) > const Duration(days: 1)) {
      return theme.onSecondary;
    }
    return theme.errorContainer;
  }
}
