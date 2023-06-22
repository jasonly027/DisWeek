import 'dart:collection';

enum Progress { incomplete, complete, checklist }

class Check {
  String title;
  bool isChecked;

  Check({
    required this.title,
    this.isChecked = false
  });
}

class Task {
  String? title;
  DateTime? due;
  List<String>? tags;
  Progress progress;
  List<Check>? checklist;
  String? description;

  Task({
    this.title,
    this.due,
    this.tags,
    this.progress = Progress.incomplete,
    this.checklist,
    this.description
  } );

}
