import 'dart:io';

import 'package:dis_week/pages/task_view/task_view.dart';
import 'package:dis_week/utils/Database.dart';
import 'package:dis_week/utils/TagHelper.dart';
import 'package:dis_week/utils/Task.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/Tag.dart';
import './widgets/widgets.dart';

class DailyView extends StatefulWidget {
  const DailyView(
      {super.key,
      required this.title,
      required this.tasks,
      required this.globalTags});

  final String title;
  final List<Task> tasks;
  final List<Tag> globalTags;

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.primaryContainer,
        title: Text(
          widget.title,
          style: TextStyle(
              color: theme.onPrimaryContainer, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: theme.onPrimaryContainer,
          onPressed: () {
            setState(() {
              // getApplicationDocumentsDirectory().then((value) {
              //   File(join(value.path, 'DisWeekTasks.db')).delete();
              // });
            });
          },
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              color: theme.onPrimaryContainer,
              icon: const Icon(Icons.calendar_month)),
          IconButton(
            onPressed: () {
              TaskDatabase.instance
                  .createTask(Task(doDay: DateTime.now()))
                  .then((value) {
                Task newTask = value;
                widget.tasks.add(newTask);

                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => TaskView(
                              task: newTask,
                              tasks: widget.tasks,
                              globalTags: widget.globalTags,
                            )))
                    .then((value) {
                  setState(() {});
                });
              });
            },
            icon: const Icon(Icons.add),
            color: theme.onPrimaryContainer,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.flip_camera_android),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView.separated(
          separatorBuilder: (context, _) => const SizedBox(height: 15),
          itemCount: widget.tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => TaskView.edit(
                              task: widget.tasks[index],
                              tasks: widget.tasks,
                              globalTags: widget.globalTags,
                            )))
                    .then((value) {
                  setState(() {});
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: theme.surfaceVariant,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TaskTitle(
                            title: widget.tasks[index].title, theme: theme),
                        if (widget.tasks[index].due != null)
                          due(date: widget.tasks[index].due!, theme: theme),
                        Wrap(
                          children: [
                            ...?LocalTag.orderTags(
                                    task: widget.tasks[index],
                                    globalTags: widget.globalTags,
                                    prune: true)
                                ?.map((tagID) => TagBox(
                                      tagID: tagID,
                                      globalTags: widget.globalTags,
                                    ))
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: ProgressIndicatorCustom(
                        task: widget.tasks[index],
                        tasks: widget.tasks,
                        tags: widget.globalTags,
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
