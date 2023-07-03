import 'package:intl/intl.dart';

import '../Notifications.dart';
import '../Utils.dart';

class TaskOperations {
  static Future<Task> createTask(Task task) async {
    final db = await TaskDatabase.instance.database;
    final id = await db.insert(tableTasks, task.toJson());

    return task.copy(id: id);
  }

  static Future<Task> readTask(int id) async {
    final db = await TaskDatabase.instance.database;

    final maps = await db.query(
      tableTasks,
      columns: TaskFields.columns,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<Task>> readTasksOnDayOf(DateTime date) async {
    final db = await TaskDatabase.instance.database;

    final result = await db.query(
      tableTasks,
      orderBy: """${TaskFields.isDone},
                    ${TaskFields.due} ${TaskDatabase.nullsLast}, 
                    ${TaskFields.id}""",
      where: """DATE(${TaskFields.doDay})
                  = 
                DATE(?,'start of day')
             """,
      whereArgs: [date.toIso8601String()],
    );

    return result.map((json) => Task.fromJson(json)).toList();
  }

  static Future<List<({String? title, int urgency})>> readTaskTitlesAndUrgency(
      DateTime date) async {
    final db = await TaskDatabase.instance.database;

    final result = await db.query(
      tableTasks,
      columns: [TaskFields.title, TaskFields.due, TaskFields.isDone],
      orderBy: """${TaskFields.isDone},
                    ${TaskFields.due} ${TaskDatabase.nullsLast}, 
                    ${TaskFields.id}""",
      where: """DATE(${TaskFields.doDay})
                  = 
                DATE(?,'start of day')
             """,
      whereArgs: [date.toIso8601String()],
    );

    return result.map((json) => Task.titleAndUrgencyFromJson(json)).toList();
  }

  static Future<List<Task>> readTasksWithinWeekOf(DateTime date) async {
    final db = await TaskDatabase.instance.database;
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));

    final result = await db.query(
      tableTasks,
      orderBy: """${TaskFields.isDone},
                  ${TaskFields.doDay},
                  ${TaskFields.due} ${TaskDatabase.nullsLast},
                  ${TaskFields.id}""",
      where: """DATE(${TaskFields.doDay})
                  BETWEEN
                    DATE(?)
                  AND
                    DATE(?, '+6 days')""",
      whereArgs: [startOfWeek.toIso8601String(), startOfWeek.toIso8601String()],
    );

    return result.map((json) => Task.fromJson(json)).toList();
  }

  static Future<int> updateTask(Task task) async {
    final db = await TaskDatabase.instance.database;

    return db.update(
      tableTasks,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> updateTaskAndNotification(Task task) async {
    final db = await TaskDatabase.instance.database;

    await NotificationsHelper.cancel(task.id!);
    if (task.notify != null && task.notify!.isAfter(DateTime.now())) {
      await NotificationsHelper.showScheduledNotification(
        id: task.id!,
        scheduledDate: task.notify!,
        title: 'Reminder for Task: ${task.title ?? 'Untitled'}',
        body: 'Due on ${DateFormat.MMMMd().format(task.due!)}',
      );
    }

    return db.update(
      tableTasks,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> deleteTask(int id) async {
    final db = await TaskDatabase.instance.database;

    return await db
        .delete(tableTasks, where: '${TaskFields.id} = ?', whereArgs: [id]);
  }
}
