enum Progress { incomplete, complete, checklist }

class Task {
  String task;
  DateTime? due;
  List<String> tags;
  Progress progress;

  Task({
    this.task = 'Untitled',
    this.due,
    required this.tags,
    this.progress = Progress.incomplete
  } );
}
