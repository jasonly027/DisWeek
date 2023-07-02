import '../utils.dart';

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
                    ${TaskFields.due}, 
                    ${TaskFields.id}""",
      where: """DATE(${TaskFields.doDay})
                  = 
                DATE(?,'start of day')
             """,
      whereArgs: [date.toIso8601String()],
    );

    return result.map((json) => Task.fromJson(json)).toList();
  }

  static Future<List<({String? title, DateTime? due})>> readTaskTitlesAndDuesOnDayOf(DateTime date) async {
    final db = await TaskDatabase.instance.database;

    final result = await db.query(
      tableTasks,
      columns: [
        TaskFields.title,
        TaskFields.due
      ],
      orderBy: """${TaskFields.isDone},
                    ${TaskFields.due}, 
                    ${TaskFields.id}""",
      where: """DATE(${TaskFields.doDay})
                  = 
                DATE(?,'start of day')
             """,
      whereArgs: [date.toIso8601String()],
    );

    return result.map((json) => Task.titleDuePairFromJson(json)).toList();
  }

  static Future<List<Task>> readTasksWithinWeekOf(DateTime date) async {
    final db = await TaskDatabase.instance.database;
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));

    final result = await db.query(
      tableTasks,
      orderBy: """${TaskFields.isDone},
                  ${TaskFields.doDay},
                  ${TaskFields.due},
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

  static Future<List<Task>> readAllTasks() async {
    final db = await TaskDatabase.instance.database;

    const orderBy = '${TaskFields.id} ASC';
    final result = await db.query(tableTasks, orderBy: orderBy);

    return result.map((json) {
      return Task.fromJson(json);
    }).toList();
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

  static Future<int> deleteTask(int id) async {
    final db = await TaskDatabase.instance.database;

    return await db
        .delete(tableTasks, where: '${TaskFields.id} = ?', whereArgs: [id]);
  }
}
