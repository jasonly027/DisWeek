import 'package:dis_week/task_components.dart';
import 'package:flutter/material.dart';
import 'theme/color_schemes.g.dart';

void main() {
  runApp(const DisWeek());
}

class DisWeek extends StatelessWidget {
  const DisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisWeek',
      theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
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
            margin: EdgeInsets.all(30),
            child: createDailyView(context, tempList),
          ),
    );
  }
}

var tempList = [
  Task(due: DateTime.now().toLocal(), tags: ['urgent', 'animal', 'go home', 'asaaaaaaaaaaaaaaaaaaaaaaaaa', 'bbbbbbbbbbbbbbb', 'casdasdasdasdasdasdas', 'd']),
  Task(due: DateTime.now().toLocal(), tags: ['late', 'home']),
];