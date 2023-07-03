import 'package:dis_week/utils/Utils.dart';

class TagOperations {
  static Future<Tag> createGlobalTag(Tag tag) async {
    final db = await TaskDatabase.instance.database;

    final id = await db.insert(tableTags, tag.toJson());
    return tag.copy(id: id);
  }

  static Future<Tag> readGlobalTag(int id) async {
    final db = await TaskDatabase.instance.database;

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

  static Future<List<Tag>> readAllGlobalTags() async {
    final db = await TaskDatabase.instance.database;

    const orderBy = '${TagFields.globalOrder} ASC';
    final result = await db.query(tableTags, orderBy: orderBy);

    return result.map((json) => Tag.fromJson(json)).toList();
  }

  static Future<int> updateGlobalTag(Tag tag) async {
    final db = await TaskDatabase.instance.database;

    return db.update(tableTags, tag.toJson(),
        where: '${TagFields.id} = ?', whereArgs: [tag.id]);
  }

  static Future<int> deleteGlobalTag(int id) async {
    final db = await TaskDatabase.instance.database;

    return await db
        .delete(tableTags, where: '${TagFields.id} = ?', whereArgs: [id]);
  }
}
