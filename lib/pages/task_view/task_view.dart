import 'package:dis_week/utils/task.dart';
import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class TaskView extends StatefulWidget {
  TaskView({Key? key})
      : title = "New Task",
        task = Task(),
        super(key: key);

  const TaskView.edit({Key? key, required this.task})
      : title = "Edit Task",
        super(key: key);

  final String title;
  final Task task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primary,
          title: Text(
            widget.title,
            style: TextStyle(color: theme.onPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const BackButtonIcon(),
            color: theme.onPrimary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              color: theme.onPrimary,
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
                headerText(
                    text: "Task Name", theme: theme, marginTop: 0),
                titleField(task: widget.task, theme: theme),
                headerText(text: "Tags", theme: theme),
                tagsList(tags: widget.task.tags, theme: theme),
                headerText(text: "Due", theme: theme),
                dueButton(date: widget.task.due, theme: theme),
                headerText(text: "Checklist", theme: theme),
                makeChecklist(
                    checklist: widget.task.checklist, theme: theme),
                headerText(text: "Description", theme: theme),
                descriptionField( task: widget.task, theme: theme),
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
                          child: TextFormField(
                            initialValue: checklist[index].title,
                            textInputAction: TextInputAction.done,
                            onChanged: (text) {
                              checklist[index].title = text;
                            },
                            onTapOutside: (context) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            maxLines: null,
                            style: const TextStyle(fontSize: 17),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none),
                          ),
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
                  setState(() {
                    widget.task.checklist ??= <Check>[];
                    widget.task.checklist!.add(Check());
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
