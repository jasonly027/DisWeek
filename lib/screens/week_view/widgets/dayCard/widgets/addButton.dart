import 'package:dis_week/screens/task_view/task_view.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/Utils.dart';

class AddButton extends StatefulWidget {
  const AddButton(
      {Key? key,
      required this.currentDateTime,
      required this.globalTags,
      required this.rebuildDayCard})
      : super(key: key);

  final DateTime currentDateTime;
  final List<Tag> globalTags;
  final void Function() rebuildDayCard;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
          onPressed: () {
            TaskOperations.createTask(Task(doDay: widget.currentDateTime))
                .then((generatedTask) {
              Task newTask = generatedTask;
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => TaskViewScreen.create(
                            task: newTask,
                            tasks: null,
                            globalTags: widget.globalTags,
                            today: widget.currentDateTime,
                          )))
                  .then((value) {
                Scrollable.ensureVisible(context, alignment: 0.5);
                widget.rebuildDayCard();
              });
            });
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: theme.tertiaryContainer),
          child: Icon(Icons.add, size: 40, color: theme.onTertiaryContainer)),
    );
  }
}
