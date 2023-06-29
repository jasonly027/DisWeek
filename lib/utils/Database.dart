// import 'package:dis_week/utils/Task.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// class TaskDatabase {
//   static final TaskDatabase instance = TaskDatabase._init();
//
//   static Database? _database;
//
//   TaskDatabase._init();
//
//   Future<Database> get database async {
//     _database ??= await _initDB('DisWeekTasks.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String fileName) async {
//     final dbPath = await getApplicationDocumentsDirectory();
//     final path = join(dbPath.path, fileName);
//
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }
//
//   Future _createDB(Database db, int version) async {
//     const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const integerType = 'INTEGER';
//     const integerTypeNotNull = 'INTEGER NOT NULL';
//     const textType = 'TEXT';
//
//     await db.execute("""
//         CREATE TABLE $tableTasks (
//           ${TaskFields.id} $idType,
//           ${TaskFields.title} $textType,
//           ${TaskFields.doDay} $integerTypeNotNull,
//           ${TaskFields.due} $textType,
//           ${TaskFields.tags} $textType,
//           ${TaskFields.progress} $integerType,
//           ${TaskFields.checklist} $textType,
//           ${TaskFields.description} $textType
//         )
//         """);
//   }
//
//   Future<Task> create(Task task) async {
//     final db = await instance.database;
//     final id = await db.insert(tableTasks, task.toJson());
//
//     return task.copy(id: id);
//   }
//
//   Future<Task> read(int id) async {
//     final db = await instance.database;
//
//     final maps = await db.query(
//       tableTasks,
//       columns: TaskFields.columns,
//       where: '${TaskFields.id} = ?',
//       whereArgs: [id],
//     );
//
//     if (maps.isNotEmpty) {
//       return Task.fromJson(maps.first);
//     } else {
//       throw Exception('ID $id not found');
//     }
//   }
//
//   Future<List<Task>> readAll() async {
//     final db = await instance.database;
//
//     const orderBy = '${TaskFields.doDay} ASC';
//     final result = await db.query(tableTasks, orderBy: orderBy);
//
//     return result.map((json) {
//       return Task.fromJson(json);
//     }).toList();
//   }
//
//   Future<int> update(Task task) async {
//     final db = await instance.database;
//
//     return db.update(
//       tableTasks,
//       task.toJson(),
//       where: '${TaskFields.id} = ?',
//       whereArgs: [task.id],
//     );
//   }
//
//   Future<int> delete(int id) async {
//     final db = await instance.database;
//
//     return await db
//         .delete(tableTasks, where: '${TaskFields.id} = ?', whereArgs: [id]);
//   }
//
//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
