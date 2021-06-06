import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sql.dart';
import 'saved_location.dart';



class DatabaseHelper {
  Future<Database> database;

  DatabaseHelper() {
    initialiseDatabase();
  }

  Future<void> initialiseDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      join(await getDatabasesPath(), "pluvia_location_database.db"),

      version: 1,

      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE locations(id INTEGER PRIMARY KEY, title TEXT, latitude DOUBLE, longitude DOUBLE)");
      },
    );
  }

  Future<void> insertLocation(SavedLocation location) async {
    final Database db = await database;

    await db.insert("locations", location.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  Future<void> clearDatabase() async {
    final Database db = await database;
    db.execute("DELETE FROM locations");
  }

  Future<void> removeLocation(int id) async {
    final db = await database;

    // Remove the location from the Database.
    await db.delete(
      "locations",
      // Use a `where` clause to delete a specific location.
      where: "id = ?",
      // Pass the id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<SavedLocation>> getLocations() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query("locations");

    return List.generate(maps.length, (index) {
      return SavedLocation(
        id: maps[index]["id"],
        title: maps[index]["title"],
        latitude: maps[index]["latitude"].toDouble(),
        longitude: maps[index]["longitude"].toDouble(),
      );
    });
  }
}

