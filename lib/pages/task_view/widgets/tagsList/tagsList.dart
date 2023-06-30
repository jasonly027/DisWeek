import 'package:dis_week/pages/task_view/widgets/headerText.dart';
import 'package:dis_week/utils/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../utils/Tag.dart';
import '../../../../utils/Task.dart';
import 'widgets/tagButton.dart';

class TagsList extends StatefulWidget {
  const TagsList({
    super.key,
    required this.task,
    required this.tasks,
    required this.globalTags,
  });

  final Task task;
  final List<Task> tasks;
  final List<Tag> globalTags;
  static const List<Color> tagColors = [
    Colors.redAccent,
    Colors.deepOrangeAccent,
    Colors.amber,
    Colors.lightGreenAccent,
    Colors.lightGreen,
    Colors.green,
    Colors.greenAccent,
    Colors.cyan,
    Colors.lightBlueAccent,
    Colors.lightBlue,
    Colors.blueGrey,
    Colors.indigo,
    Colors.deepPurple,
    Colors.purple,
    Colors.pinkAccent,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.grey,
    Colors.white,
  ];

  static void sortTags(
          {required List<Tag>? unsorted, required List<Tag> sorted}) =>
      unsorted?.sort((a, b) => sorted
          .indexWhere((tag) => tag.equals(a))
          .compareTo(sorted.indexWhere((tag) => tag.equals(b))));

  static void calculateGlobalOrder(List<Tag> tags) {
    for (int i = 0; i < tags.length; ++i) {
      tags[i].globalOrder = i;
      TaskDatabase.instance.updateTag(tags[i]);
    }
  }

  @override
  State<TagsList> createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Wrap(children: [
      ...?widget.task.tags
          ?.map((tag) => TagButton(
              onPressed: () {
                setState(() {
                  widget.task.tags!.remove(tag);
                  if (widget.task.tags!.isEmpty) {
                    widget.task.tags = null;
                  }
                  TaskDatabase.instance.updateTask(widget.task);
                });
              },
              textColor: tag.color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              backgroundColor: tag.color,
              title: tag.name))
          .toList(),
      TagButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                    builder: (context, setDialogState) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const headerText(
                                      text: 'Edit Tags', marginTop: 5),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      child: ReorderableListView(
                                        onReorder: (oldIndex, tempNewIndex) {
                                          setDialogState(() {
                                            final newIndex =
                                                tempNewIndex > oldIndex
                                                    ? tempNewIndex - 1
                                                    : tempNewIndex;
                                            final tag = widget.globalTags
                                                .removeAt(oldIndex);
                                            widget.globalTags
                                                .insert(newIndex, tag);
                                            TagsList.calculateGlobalOrder(
                                                widget.globalTags);
                                          });
                                          setState(() {
                                            for (var task in widget.tasks) {
                                              TagsList.sortTags(
                                                  unsorted: task.tags,
                                                  sorted: widget.globalTags);
                                              TaskDatabase.instance
                                                  .updateTask(task);
                                            }
                                          });
                                        },
                                        onReorderStart: (index) =>
                                            HapticFeedback.lightImpact(),
                                        children: widget.globalTags
                                            .map((globalTag) => Row(
                                                  key: ValueKey(globalTag),
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Checkbox(
                                                          value: widget
                                                                  .task.tags
                                                                  ?.any((tag) =>
                                                                      tag.equals(
                                                                          globalTag)) ??
                                                              false,
                                                          activeColor:
                                                              theme.primary,
                                                          onChanged:
                                                              (bool? value) {
                                                            setDialogState(() {
                                                              if (value!) {
                                                                widget.task
                                                                        .tags ??=
                                                                    <Tag>[];
                                                                widget
                                                                    .task.tags!
                                                                    .add(
                                                                        globalTag);
                                                              } else {
                                                                widget
                                                                    .task.tags!
                                                                    .removeWhere(
                                                                        (tag) =>
                                                                            tag.equals(globalTag));
                                                                if (widget
                                                                    .task
                                                                    .tags!
                                                                    .isEmpty) {
                                                                  widget.task
                                                                          .tags =
                                                                      null;
                                                                }
                                                              }
                                                              TagsList.sortTags(
                                                                  unsorted:
                                                                      widget
                                                                          .task
                                                                          .tags,
                                                                  sorted: widget
                                                                      .globalTags);
                                                              TaskDatabase
                                                                  .instance
                                                                  .updateTask(
                                                                      widget
                                                                          .task);
                                                            });
                                                            setState(() {});
                                                          }),
                                                    ),
                                                    Expanded(
                                                      flex: 9,
                                                      child: TextFormField(
                                                        initialValue:
                                                            globalTag.name,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        onChanged: (text) {
                                                          globalTag.name = text;
                                                          TaskDatabase.instance
                                                              .updateTag(
                                                                  globalTag);
                                                        },
                                                        onTapOutside:
                                                            (context) {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        maxLines: null,
                                                        style: const TextStyle(
                                                            fontSize: 17),
                                                        decoration:
                                                            const InputDecoration(
                                                                hintText:
                                                                    'Add a label',
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title: const Text(
                                                                            'Pick a Color'),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                                child: BlockPicker(
                                                                          pickerColor:
                                                                              globalTag.color,
                                                                          onColorChanged: (newColor) =>
                                                                              setDialogState(() {
                                                                            globalTag.color =
                                                                                newColor;
                                                                            TaskDatabase.instance.updateTag(globalTag);
                                                                          }),
                                                                          availableColors:
                                                                              TagsList.tagColors,
                                                                        )),
                                                                      )).then(
                                                              (value) =>
                                                                  setState(
                                                                      () {}));
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            minimumSize:
                                                                const Size
                                                                    .square(25),
                                                            backgroundColor:
                                                                globalTag.color,
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .zero)),
                                                        child: null,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(Icons
                                                                .drag_indicator))),
                                                    Expanded(
                                                        flex: 2,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setDialogState(() {
                                                              for (Task task
                                                                  in widget
                                                                      .tasks) {
                                                                task.tags?.removeWhere(
                                                                    (tag) => tag
                                                                        .equals(
                                                                            globalTag));
                                                                if (task.tags
                                                                        ?.isEmpty ??
                                                                    false) {
                                                                  task.tags =
                                                                      null;
                                                                }
                                                                TaskDatabase
                                                                    .instance
                                                                    .updateTask(
                                                                        task);
                                                              }
                                                              TaskDatabase
                                                                  .instance
                                                                  .deleteTag(
                                                                      globalTag
                                                                          .id!);
                                                              widget.globalTags
                                                                  .remove(
                                                                      globalTag);
                                                              setState(() {});
                                                            });
                                                          },
                                                          icon: const Icon(
                                                              Icons.close),
                                                        )),
                                                  ],
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: TextButton(
                                        onPressed: () {
                                          TaskDatabase.instance
                                              .createTag(Tag(
                                                  color: Colors.white,
                                                  globalOrder: widget
                                                          .globalTags.isNotEmpty
                                                      ? (widget.globalTags.last
                                                              .globalOrder! +
                                                          1)
                                                      : 0))
                                              .then((value) {
                                            setDialogState(() {
                                              Tag newTag = value;
                                              widget.globalTags.add(newTag);
                                            });
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                        ),
                                        child: const Text(
                                          'New Tag',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  )
                                ]),
                          ),
                        )));
          },
          textColor: theme.onTertiaryContainer,
          backgroundColor: theme.tertiaryContainer,
          title: "   +   ")
    ]);
  }
}
