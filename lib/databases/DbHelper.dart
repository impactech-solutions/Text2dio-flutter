import 'package:Text2dio/model/TextModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DbHelper {
  Database _database;
  // ignore: non_constant_identifier_names
  static final String DB_NAME = "text2dio.db";
  // ignore: non_constant_identifier_names
  static final String TB_NAME = "text_tb";

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), DB_NAME),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE $TB_NAME (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              title TEXT UNIQUE NOT NULL,
              body Text NOT NULL,
              date_created TEXT
            );''');
      });
    }
  }

  Future<int> saveText(TextModel textModel) async {
    //textModel.date_created = DateTime.now().toString();
    print(textModel.date_created);
    try {
      await openDb();
      return (await _database.query(TB_NAME,
                      where: "title = ?", whereArgs: [textModel.title]))
                  .length <
              1
          ? _database.insert(TB_NAME, textModel.toMap())
          : -1;
    } on Exception catch (e) {
      print(e);
      return -1;
    }
  }

  Future<List<TextModel>> getTextList() async {
    await openDb();

    List<Map<String, dynamic>> maps = await _database.query(TB_NAME);

    return List.generate(maps.length, (i) {
      return TextModel(
          id: maps[i]['id'],
          title: maps[i]['title'],
          body: maps[i]['body'],
          date_created: maps[i]['date_created']);
    });
  }

  Future<int> updateText(TextModel textModel) async {
    await openDb();
    return await _database.update(TB_NAME, textModel.toMap(),
        where: "id = ?", whereArgs: [textModel.id]);
  }

  Future<int> deleteText(int id) async {
    await openDb();
    return await _database.delete(TB_NAME, where: "id = ?", whereArgs: [id]);
  }

  Future<List<TextModel>> searchText(String title) async {
    await openDb();
    List<Map<String, dynamic>> maps =
        await _database.query(TB_NAME, where: "title = ?", whereArgs: [title]);
    return List.generate(maps.length, (i) {
      return TextModel(
          body: maps[0]["body"],
          id: maps[0]["id"],
          title: maps[0]["title"],
          date_created: maps[0]["date_created"]);
    });
  }
}
