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

  static Future<List<List>> multiRead(List<Future<List>> reads) async {
    List<List> ret = <List>[];
    for (var read in reads) {
      ret.add(await read);
    }
    return ret;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
