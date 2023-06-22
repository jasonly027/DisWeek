import 'package:dis_week/pages/task_view_helper.dart';
import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  TaskView({Key? key})
      : title = "New Task",
        task = Task(),
        super(key: key);

  TaskView.edit({Key? key, required this.task})
      : title = "Edit Task",
        super(key: key);

  final String title;
  final Task task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme themeColor = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor.primary,
          title: Text(
            widget.title,
            style: TextStyle(color: themeColor.onPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const BackButtonIcon(),
            color: themeColor.onPrimary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              color: themeColor.onPrimary,
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                makeHeaderText(
                    text: "Task Name", color: themeColor.primary, marginTop: 0),
                makeTitleField(controller: _nameController, theme: themeColor),
                makeHeaderText(text: "Tags", color: themeColor.primary),
                makeTagList(tags: widget.task.tags, theme: themeColor),
                makeHeaderText(text: "Due", color: themeColor.primary),
                makeDueButton(date: widget.task.due, theme: themeColor),
                makeHeaderText(text: "Checklist", color: themeColor.primary),
                makeChecklist(
                    checklist: widget.task.checklist, theme: themeColor),
                makeHeaderText(text: "Description", color: themeColor.primary),
                makeDescriptionField(
                    controller: _descriptionController, theme: themeColor),
              ],
            ),
          ),
        ));
  }

  Widget makeChecklist({List<Check>? checklist, required ColorScheme theme}) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          border: Border.all(color: theme.inversePrimary),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          checklist != null
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: checklist.length,
                  itemBuilder: (BuildContext context, int index) {
                    final TextEditingController title =
                        TextEditingController(text: checklist[index].title);

                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Checkbox(
                              value: checklist[index].isChecked,
                              activeColor: theme.primary,
                              onChanged: (bool? value) {
                                setState(() {
                                  checklist[index].isChecked = value!;
                                });
                              }),
                        ),
                        Expanded(
                          flex: 8,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    checklist[index].isChecked =
                                        !checklist[index].isChecked;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 16),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: title,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none
                                    ),
                                  ),
                                )),
                          ),
                      ],
                    );
                  },
                )
              : const SizedBox.shrink(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  // checklist.add()
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
