import 'package:dis_week/pages/dailyView.dart';
import 'package:flutter/material.dart';
import 'package:dis_week/theme/color_schemes.g.dart';
import 'package:dis_week/utils/task.dart';

void main() {
  runApp(const DisWeek());
}

class DisWeek extends StatelessWidget {
  const DisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisWeek',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const Notes(title: 'Today'),
    );
  }
}

class Notes extends StatefulWidget {
  const Notes({super.key, required this.title});
  final String title;

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: Text(widget.title,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            setState(() {
              print("setStating");
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {

            },
          )
        ],
      ),
      body:
      Container(
        margin: const EdgeInsets.all(20),
        child: createDailyView(context, tempList),
      ),
    );
  }
}

var tempList = [
  Task(due: DateTime.now().toLocal(), tags: ['urgent', 'animal', 'go home', 'asaaaaaaaaaaaaaaaaaaaaaaaaa', 'bbbbbbbbbbbbbbb', 'casdasdasdasdasdasdas', 'd']),
  Task(due: DateTime.now().toLocal(), tags: ['late', 'home']),
];