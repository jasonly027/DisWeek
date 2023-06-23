import 'package:flutter/material.dart';

import '../../../utils/task.dart';

class progress_indicator extends StatelessWidget {
  const progress_indicator({
    super.key,
    required this.progress,
    required this.theme
  });

  final Progress progress;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(2),
        child: IconButton.filled(
          color: theme.onTertiary,
          icon: const Icon(Icons.check),
          iconSize: 25,
          onPressed: () {
            switch (progress) {
              case Progress.checklist:
              //
              case Progress.incomplete:
              //
              case Progress.complete:
              //
            }
          },
        ));
  }
}
