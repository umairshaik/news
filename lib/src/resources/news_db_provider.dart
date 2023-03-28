import 'dart:io';
import 'package:news/src/model/item_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:path/path.dart' show join;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class NewsDBProvider implements Source, Cache {
  late Database db;

  NewsDBProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");

    //databaseFactory.deleteDatabase(path);
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (newDb, version) {
        newDb.execute("""
          CREATE TABLE Items (
              id INTEGER PRIMARY KEY, 
              type TEXT, 
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )""");
      },
    );
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromDB(maps.first);
    }
    return null;
  }

  @override
  Future<int> addItem(ItemModel itemModel) async {
    return db.insert(
      "Items",
      itemModel.toMapForDB(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<int>>? fetchTopIDs() {
    return null;
  }

  @override
  Future<int> clearCache() {
    return db.delete("Items");
  }
}

final newsDBprovider = NewsDBProvider();
