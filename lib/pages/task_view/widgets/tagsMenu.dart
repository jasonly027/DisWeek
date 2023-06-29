import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../utils/Tag.dart';
import '../../../utils/Task.dart';
import 'headerText.dart';

class TagsMenu extends StatefulWidget {
  const TagsMenu({
    Key? key,
    required this.task,
    required this.tasks,
    required this.globalTags,
    required this.toggle,
  }) : super(key: key);

  final Task task;
  final List<Task> tasks;
  final List<Tag> globalTags;
  final void Function(bool value) toggle;
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

  @override
  State<TagsMenu> createState() => _TagsMenuState();
}

class _TagsMenuState extends State<TagsMenu> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Stack(alignment: Alignment.center, children: [
      GestureDetector(
        onTap: () {
          widget.toggle(false);
        },
        child: Container(
          color: theme.shadow.withOpacity(0.7),
        ),
      ),
      SizedBox(
        height: deviceHeight * 0.6,
        width: deviceWidth * 0.93,
        child: Card(
          color: theme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: SingleChildScrollView(
              child: Column(children: [
                headerText(
                  text: "Edit Tags",
                  textColor: theme.onSurface,
                ),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: true,
                  onReorder: (oldIndex, tempNewIndex) {
                    setState(() {
                      final newIndex = tempNewIndex > oldIndex
                          ? tempNewIndex - 1
                          : tempNewIndex;
                      final tag = widget.globalTags.removeAt(oldIndex);
                      widget.globalTags.insert(newIndex, tag);
                      TagsMenu.sortTags(
                          unsorted: widget.task.tags, sorted: widget.globalTags);
                    });
                  },
                  onReorderStart: (index) => HapticFeedback.lightImpact(),
                  children: widget.globalTags
                      .map((globalTag) => Row(
                            key: ValueKey(globalTag),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Checkbox(
                                    value: widget.task.tags?.any(
                                            (tag) => tag.equals(globalTag)) ??
                                        false,
                                    activeColor: theme.primary,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          widget.task.tags ??= <Tag>[];
                                          widget.task.tags!.add(globalTag);
                                        } else {
                                          widget.task.tags!.removeWhere(
                                              (tag) => tag.equals(globalTag));
                                          if (widget.task.tags!.isEmpty) {
                                            widget.task.tags = null;
                                          }
                                        }
                                        TagsMenu.sortTags(
                                            unsorted: widget.task.tags,
                                            sorted: widget.globalTags);
                                      });
                                    }),
                              ),
                              Expanded(
                                flex: 9,
                                child: TextFormField(
                                  initialValue: globalTag.name,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (text) {
                                    globalTag.name = text;
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
                              Flexible(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text('Pick a Color'),
                                              content: SingleChildScrollView(
                                                  child: BlockPicker(
                                                pickerColor: globalTag.color,
                                                onColorChanged: (newColor) =>
                                                    setState(() {
                                                  globalTag.color = newColor;
                                                }),
                                                availableColors:
                                                    TagsMenu.tagColors,
                                              )),
                                            ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.square(25),
                                      backgroundColor: globalTag.color,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero)),
                                  child: null,
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.drag_indicator))),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        for (Task task in widget.tasks) {
                                          task.tags?.removeWhere(
                                              (tag) => tag.equals(globalTag));
                                        }
                                        widget.globalTags.remove(globalTag);
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  )),
                            ],
                          ))
                      .toList(),
                ),
                SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      widget.globalTags.add(Tag(color: Colors.white));
                      // TaskDatabase.instance.update(widget.task);
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                  child: const Text(
                    'New Tag',
                    style: TextStyle(fontSize: 16),
                  )),
          )
              ]),
            ),
          ),
        ),
      )
    ]);
  }
}
