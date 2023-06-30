import 'package:dis_week/utils/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dis_week/utils/Check.dart';

import '../../../utils/Task.dart';

class Checklist extends StatefulWidget {
  const Checklist({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          border: Border.all(color: theme.inversePrimary),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          if (widget.task.checklist?.isNotEmpty ?? false)
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: true,
              onReorder: (oldIndex, tempNewIndex) {
                setState(() {
                  final newIndex =
                      tempNewIndex > oldIndex ? tempNewIndex - 1 : tempNewIndex;
                  final item = widget.task.checklist!.removeAt(oldIndex);
                  widget.task.checklist!.insert(newIndex, item);
                  TaskDatabase.instance.updateTask(widget.task);
                });
              },
              onReorderStart: (index) => HapticFeedback.lightImpact(),
              children: widget.task.checklist!
                  .map((item) => Row(
                        key: ValueKey(item),
                        children: [
                          Expanded(
                            flex: 2,
                            child: Checkbox(
                                value: item.isChecked,
                                activeColor: theme.primary,
                                onChanged: (bool? value) {
                                  setState(() {
                                    item.isChecked = value!;
                                    TaskDatabase.instance.updateTask(widget.task);
                                  });
                                }),
                          ),
                          Expanded(
                            flex: 9,
                            child: TextFormField(
                              initialValue: item.title,
                              textInputAction: TextInputAction.done,
                              onChanged: (text) {
                                item.title = text;
                                TaskDatabase.instance.updateTask(widget.task);
                              },
                              onTapOutside: (context) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              maxLines: null,
                              style: const TextStyle(fontSize: 17),
                              decoration: const InputDecoration(
                                  hintText: 'Add a label',
                                  contentPadding: EdgeInsets.all(5),
                                  border: InputBorder.none),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.task.checklist!.remove(item);
                                    if (widget.task.checklist!.isEmpty) {
                                      widget.task.checklist = null;
                                    }
                                    TaskDatabase.instance.updateTask(widget.task);
                                  });
                                },
                                icon: const Icon(Icons.close),
                              )),
                          Expanded(
                              flex: 2,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.drag_indicator)))
                        ],
                      ))
                  .toList(),
            ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    widget.task.checklist ??= <Check>[];
                    widget.task.checklist!.add(Check());
                    TaskDatabase.instance.updateTask(widget.task);
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
                child: const Text(
                  'Add Item',
                  style: TextStyle(fontSize: 16),
                )),
          )
        ],
      ),
    );
  }
}
