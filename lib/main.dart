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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(widget.title,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello"),
          ],
        ),
      ),
    );
  }
}
