import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/Tag.dart';
import '../../../utils/Task.dart';
import 'headerText.dart';

class TagsMenu extends StatefulWidget {
  const TagsMenu({
    Key? key,
    required this.task,
    required this.globalTags,
    required this.toggle,
  }) : super(key: key);

  final Task task;
  final List<Tag> globalTags;
  final void Function(bool value) toggle;

  @override
  State<TagsMenu> createState() => _TagsMenuState();
}

class _TagsMenuState extends State<TagsMenu> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Stack(alignment: Alignment.center, children: [
      GestureDetector(
        onTap: () {
          widget.toggle(false);
        },
        child: Container(
          color: theme.shadow.withOpacity(0.7),
        ),
      ),
      Container(
        height: deviceHeight * 0.65,
        width: deviceWidth * 0.85,
        child: Card(
          color: theme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                    // final newIndex =
                    // tempNewIndex > oldIndex ? tempNewIndex - 1 : tempNewIndex;
                    // final item = widget.task.checklist!.removeAt(oldIndex);
                    // widget.task.checklist!.insert(newIndex, item);
                  });
                },
                onReorderStart: (index) => HapticFeedback.lightImpact(),
                children: widget.globalTags
                    .map((item) => Row(
                          key: ValueKey(item),
                          children: [
                            Expanded(
                              flex: 2,
                              child: Checkbox(
                                  value: null,
                                  activeColor: theme.primary,
                                  onChanged: (bool? value) {
                                    setState(() {

                                    });
                                  }),
                            ),
                            Expanded(
                              flex: 9,
                              child: TextFormField(
                                initialValue: item.name,
                                textInputAction: TextInputAction.done,
                                onChanged: (text) {
                                  item.name = text;
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
                                    setState(() {});
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
            ]),
          ),
        ),
      )
    ]);
  }
}
