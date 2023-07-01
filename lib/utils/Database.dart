import 'package:dis_week/utils/Tag.dart';
import 'package:dis_week/utils/Task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();

  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    _database ??= await _initDB('DisWeekTasks.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER';
    const integerTypeNotNull = 'INTEGER NOT NULL';
    const textType = 'TEXT';

    await db.execute("""
        CREATE TABLE $tableTasks (
          ${TaskFields.id} $idType,
          ${TaskFields.title} $textType,
          ${TaskFields.doDay} $integerTypeNotNull,
          ${TaskFields.due} $textType,
          ${TaskFields.tags} $textType,
          ${TaskFields.isDone} $integerType,
          ${TaskFields.checklist} $textType,
          ${TaskFields.description} $textType
        )
        """);

    await db.execute("""
      CREATE TABLE $tableTags (
        ${TagFields.id} $idType,
        ${TagFields.name} $textType,
        ${TagFields.color} $integerType,
        ${TagFields.globalOrder} $integerType
      )
    """);
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(tableTasks, task.toJson());

    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;

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

  Future<List<Task>> readTasksOnDayOf(DateTime date) async {
    final db = await instance.database;

    final result = await db.query(tableTasks,
        orderBy: """${TaskFields.isDone},
                    ${TaskFields.due}, 
                    ${TaskFields.id}""",
        where:
            """DATE(${TaskFields.doDay})
                  BETWEEN 
                    DATE(?,'start of day')
                  AND
                    DATE(?, 'start of day', '+1 day')""",
        whereArgs: [date.toIso8601String(), date.toIso8601String()],
    );

    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<List<Task>> readTasksWithinWeekOf(DateTime date) async {
    final db = await instance.database;
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));

    final result = await db.query(tableTasks,
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



  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;

    const orderBy = '${TaskFields.id} ASC';
    final result = await db.query(tableTasks, orderBy: orderBy);

    return result.map((json) {
      return Task.fromJson(json);
    }).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;

    return db.update(
      tableTasks,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableTasks, where: '${TaskFields.id} = ?', whereArgs: [id]);
  }

  Future<Tag> createGlobalTag(Tag tag) async {
    final db = await instance.database;

    final id = await db.insert(tableTags, tag.toJson());
    return tag.copy(id: id);
  }

  Future<Tag> readGlobalTag(int id) async {
    final db = await instance.database;

    final map = await db.query(tableTags,
        columns: TagFields.columns,
        where: '${TagFields.id} = ?',
        whereArgs: [id]);

    if (map.isNotEmpty) {
      return Tag.fromJson(map.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Tag>> readAllGlobalTags() async {
    final db = await instance.database;

    const orderBy = '${TagFields.globalOrder} ASC';
    final result = await db.query(tableTags, orderBy: orderBy);

    return result.map((json) => Tag.fromJson(json)).toList();
  }

  Future<int> updateGlobalTag(Tag tag) async {
    final db = await instance.database;

    return db.update(tableTags, tag.toJson(),
        where: '${TagFields.id} = ?', whereArgs: [tag.id]);
  }

  Future<int> deleteGlobalTag(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableTags, where: '${TagFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
