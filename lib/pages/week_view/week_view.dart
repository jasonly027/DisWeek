import 'package:flutter/material.dart';

class WeekView extends StatefulWidget {
  const WeekView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
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
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              color: theme.onPrimaryContainer,
              icon: const Icon(Icons.calendar_month)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.flip_camera_android),
      ),
    );
  }
}
