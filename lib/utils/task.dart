import 'dart:convert';
import 'dart:core';

const String tableTasks = 'tasks';

class TaskFields {
  static const List<String> columns = [
    id,
    title,
    doDay,
    due,
    tags,
    progress,
    checklist,
    description
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String doDay = 'doDay';
  static const String due = 'due';
  static const String tags = 'tags';
  static const String progress = 'progress';
  static const String checklist = 'checklist';
  static const String description = 'description';
}

class Task {
  final int? id;
  String? title;
  DateTime doDay;
  DateTime? due;
  List<String>? tags;
  Progress progress;
  List<Check>? checklist;
  String? description;

  Task(
      {this.id,
      this.title,
      required this.doDay,
      this.due,
      this.tags,
      this.progress = Progress.incomplete,
      this.checklist,
      this.description});

  Task copy({
    int? id,
    String? title,
    DateTime? doDay,
    DateTime? due,
    List<String>? tags,
    Progress? progress,
    List<Check>? checklist,
    String? description,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        doDay: doDay ?? this.doDay,
        due: due ?? this.due,
        tags: tags ?? this.tags,
        progress: progress ?? this.progress,
        checklist: checklist ?? this.checklist,
        description: description ?? this.description,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
      id: json[TaskFields.id] as int?,
      title: json[TaskFields.title] as String?,
      doDay: DateTime.parse(json[TaskFields.doDay] as String),
      due: json[TaskFields.due] != null
          ? DateTime.parse(json[TaskFields.due] as String)
          : null,
      tags: json[TaskFields.tags] != null
          ? List<String>.from(jsonDecode(json[TaskFields.tags] as String))
          : null,
      progress: Progress.values[json[TaskFields.progress] as int],
      checklist: json[TaskFields.checklist] != null
          ? (jsonDecode(json[TaskFields.checklist] as String) as List).map((item) {
              return Check.fromJson(item);
            }).toList()
          : null,
      description: json[TaskFields.description] as String?);

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.doDay: doDay.toIso8601String(),
        TaskFields.due: due?.toIso8601String(),
        TaskFields.tags: tags != null ? jsonEncode(tags) : null,
        TaskFields.progress: progress.index,
        TaskFields.checklist: checklist != null ? jsonEncode(checklist) : null,
        TaskFields.description: description,
      };
}

enum Progress { incomplete, complete, checklist }

class Check {
  String? title;
  bool isChecked;

  Check({this.title, this.isChecked = false});

  Check.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        isChecked = json['isChecked'] as bool;

  Map<String, dynamic> toJson() => {
        'title': title,
        'isChecked': isChecked,
      };
}
