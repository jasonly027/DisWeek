import 'package:dis_week/pages/task_view/widgets/headerText.dart';
import 'package:dis_week/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'widgets/tagButton.dart';

class TagsList extends StatefulWidget {
  const TagsList({
    super.key,
    required this.task,
    required this.globalTags,
  });

  final Task task;
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

  @override
  State<TagsList> createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Wrap(children: [
      ...?widget.task.tags
          ?.map((tagID) => TagButton(
              onPressed: () {
                setState(() {
                  LocalTag.removeTag(task: widget.task, tagID: tagID);
                });
              },
              textColor: getGlobalTag(tagID, widget.globalTags).color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              backgroundColor: getGlobalTag(tagID, widget.globalTags).color,
              title: getGlobalTag(tagID, widget.globalTags).name))
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
                                            GlobalTag.calculateGlobalOrder(
                                                widget.globalTags);
                                          });
                                          setState(() {
                                            // for (var task in widget.tasks) {
                                            //   LocalTagHelper.reorderTags(
                                            //       task: task,
                                            //       globalTags:
                                            //           widget.globalTags);
                                            // }
                                            // TODO: MOVE REORDER RESPONSIBILITY
                                            LocalTag.orderTags(task: widget.task, globalTags: widget.globalTags);
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
                                                          value: widget .task.tags ?.contains(globalTag.id) ?? false,
                                                          activeColor:
                                                              theme.primary,
                                                          onChanged:
                                                              (bool? value) {
                                                            setDialogState(() {
                                                              if (value!) {
                                                                LocalTag.addTag(task: widget.task, tagID: globalTag.id!);
                                                              } else {
                                                                LocalTag.removeTag(task: widget.task, tagID: globalTag.id!);
                                                              }
                                                              LocalTag.orderTags(
                                                                  task: widget
                                                                      .task,
                                                                  globalTags: widget
                                                                      .globalTags);
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
                                                          setState(() {
                                                            GlobalTag.renameTag(globalTag: globalTag, name: text);
                                                          });
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
                                                                                child: BlockPicker( pickerColor: globalTag.color, onColorChanged: (newColor) =>
                                                                              setDialogState(() {
                                                                            GlobalTag.recolorTag(globalTag: globalTag, color: newColor);
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
                                                              // for (Task task in widget .tasks) {
                                                              //   task.tags?.removeWhere( (tag) => tag .equals( globalTag));
                                                              //   if (task.tags ?.isEmpty ?? false) {
                                                              //     task.tags = null;
                                                              //   }
                                                              //   TaskDatabase .instance .updateTask( task);
                                                              // }
                                                              // TODO: Move pruning responsibility
                                                              LocalTag.removeTag(task: widget.task, tagID: globalTag.id!);
                                                              GlobalTag.removeTag(globalTag: globalTag, globalTags: widget.globalTags);
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
                                              .createGlobalTag(Tag(
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
