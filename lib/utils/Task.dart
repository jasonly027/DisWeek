import 'dart:convert';
import 'dart:core';

import 'Check.dart';

const String tableTasks = 'tasks';

class TaskFields {
  static const List<String> columns = [
    id,
    title,
    doDay,
    due,
    notify,
    tags,
    isDone,
    checklist,
    description
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String doDay = 'doDay';
  static const String due = 'due';
  static const String notify = 'notify';
  static const String tags = 'tags';
  static const String isDone = 'isDone';
  static const String checklist = 'checklist';
  static const String description = 'description';
}

class Task {
  final int? id;
  String? title;
  DateTime doDay;
  DateTime? due;
  DateTime? notify;
  List<int>? tags;
  bool isDone;
  List<Check>? checklist;
  String? description;

  Task(
      {this.id,
      this.title,
      required DateTime doDay,
      this.due,
      this.notify,
      this.tags,
      this.isDone = false,
      this.checklist,
      this.description})
      : doDay = DateTime(doDay.year, doDay.month, doDay.day);

  Task copy({
    int? id,
    String? title,
    DateTime? doDay,
    DateTime? due,
    DateTime? notify,
    List<int>? tags,
    bool? isDone,
    List<Check>? checklist,
    String? description,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        doDay: doDay ?? this.doDay,
        due: due ?? this.due,
        notify: notify ?? this.notify,
        tags: tags ?? this.tags,
        isDone: isDone ?? this.isDone,
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
      notify: json[TaskFields.notify] != null
          ? DateTime.parse(json[TaskFields.notify] as String)
          : null,
      tags: json[TaskFields.tags] != null
          ? (jsonDecode(json[TaskFields.tags] as String) as List)
              .map((item) => item as int)
              .toList()
          : null,
      isDone: json[TaskFields.isDone] == 1,
      checklist: json[TaskFields.checklist] != null
          ? (jsonDecode(json[TaskFields.checklist] as String) as List)
              .map((item) => Check.fromJson(item))
              .toList()
          : null,
      description: json[TaskFields.description] as String?);

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.doDay: doDay.toIso8601String(),
        TaskFields.due: due?.toIso8601String(),
        TaskFields.notify: notify?.toIso8601String(),
        TaskFields.tags: tags != null ? jsonEncode(tags) : null,
        TaskFields.isDone: isDone ? 1 : 0,
        TaskFields.checklist: checklist != null ? jsonEncode(checklist) : null,
        TaskFields.description: description,
      };

  static bool isUrgent(Task task) {
    if (task.isDone || task.due == null) return false;
    return task.due!.difference(DateTime.now()) <= const Duration(days: 1);
  }

  static ({String? title, int urgency}) titleAndUrgencyFromJson(
      Map<String, Object?> json) {
    String? title = json[TaskFields.title] as String?;
    DateTime? due = json[TaskFields.due] != null
        ? DateTime.parse(json[TaskFields.due] as String)
        : null;
    bool isDone = json[TaskFields.isDone] == 1;
    int urgency;
    if (isDone) {
      urgency = -1;
    } else if (due == null) {
      urgency = 0;
    } else {
      urgency =
          due.difference(DateTime.now()) <= const Duration(days: 1) ? 1 : 0;
    }
    return (title: title, urgency: urgency);
  }

  static const List<({String string, Duration? duration})> notifyOptions = [
    (string: 'Do not remind me', duration: null),
    (string: '1 Week before', duration: Duration(days: 7)),
    (string: '2 Days before', duration: Duration(days: 2)),
    (string: '1 Day before', duration: Duration(days: 1)),
    (string: '12 Hours before', duration: Duration(hours: 12)),
    (string: '1 Hour before', duration: Duration(hours: 1)),
    (string: '30 Minutes before', duration: Duration(minutes: 30)),
    (string: '5 Minutes before', duration: Duration(minutes: 5)),
    (string: 'On Due', duration: Duration()),
  ];
}
