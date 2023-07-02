import 'package:flutter/material.dart';
import '../../../../../utils/database/taskOperations.dart';

class TaskTitleList extends StatelessWidget {
  TaskTitleList(this.currentDateTime, {Key? key})
      : taskStats = TaskOperations.readTaskTitlesAndIsUrgent(currentDateTime),
        super(key: key);

  final DateTime currentDateTime;
  final Future<List<({String? title, bool isUrgent})>?> taskStats;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    final scrollController = ScrollController();

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      height: 175,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: theme.secondary),
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: FutureBuilder(
            future: taskStats,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  !snapshot.hasData) {
                return ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      "Refreshing...",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: theme.onSecondary),
                    ),
                  ],
                );
              } else {
                List<({String? title, bool isUrgent})> taskStats =
                    snapshot.data;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: taskStats.length,
                  itemBuilder: (context, taskIndex) {
                    return Text(
                      taskStats[taskIndex].title ?? 'Untitled',
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: taskStats[taskIndex].isUrgent
                              ? theme.errorContainer
                              : theme.onSecondary),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
