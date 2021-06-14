import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:vinyl/servers/Favorites.dart';

class FavoritesDatabase{
  Database database;

  initDB() async {
    database = await openDatabase('favorites.db', version: 1,
        onCreate: (Database db, int version){
          db.execute("CREATE TABLE favs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)");
        }
    );
    print('DB INITIALIZED');
  }

  insert(Favorite favorite) async {
    database.insert('favs', favorite.toMap());
  }
  
  Future<List<Favorite>> getAllFavorites() async {
    List<Map<String, dynamic>> results = await database.query('favs');
    return results.map((map) => Favorite.fromMap(map)).toList();
  }

  Future<List<Map>> read()async{
    List<Map> list = await database.rawQuery('SELECT * FROM favs');
    return list;
  }

  delete(Favorite favorite) async {
    int count = await database.rawDelete('DELETE FROM favs WHERE name = ?', [favorite.name]);
    assert(count == 1);
  }
}