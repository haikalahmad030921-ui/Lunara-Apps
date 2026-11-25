import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../data/beach_data.dart';
import '../models/beach.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const _dbName = 'lunara_beaches.db';
  static const _tableBeaches = 'beaches';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final dbPath = kIsWeb ? _dbName : '${await getDatabasesPath()}/$_dbName';

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableBeaches (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            location TEXT NOT NULL,
            fullAddress TEXT NOT NULL,
            categoryTag TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            distanceKm REAL NOT NULL,
            travelTime TEXT NOT NULL,
            rating REAL NOT NULL,
            reviewCount INTEGER NOT NULL,
            ticketPrice TEXT NOT NULL,
            bestTime TEXT NOT NULL,
            status TEXT NOT NULL,
            visitedDate TEXT,
            tags TEXT NOT NULL,
            highlightNote TEXT NOT NULL,
            journalQuote TEXT,
            extraTips TEXT,
            windAndWave TEXT NOT NULL,
            highTideTime TEXT NOT NULL,
            routeSummary TEXT NOT NULL,
            facilities TEXT NOT NULL,
            galleryUrls TEXT NOT NULL,
            isBookmarked INTEGER NOT NULL,
            mapX REAL NOT NULL,
            mapY REAL NOT NULL
          )
        ''');

        for (final beach in BeachData.initialBeaches) {
          await db.insert(
            _tableBeaches,
            beach.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      },
    );
  }

  Future<List<Beach>> getBeaches() async {
    final db = await database;
    final maps = await db.query(_tableBeaches);
    return maps.map(Beach.fromMap).toList();
  }

  Future<void> insertBeach(Beach beach) async {
    final db = await database;
    await db.insert(
      _tableBeaches,
      beach.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> toggleBookmark(String id, bool isBookmarked) async {
    final db = await database;
    await db.update(
      _tableBeaches,
      {'isBookmarked': isBookmarked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateBeachLocation(
    String id,
    double mapX,
    double mapY,
    double distanceKm,
    String travelTime,
  ) async {
    final db = await database;
    await db.update(
      _tableBeaches,
      {
        'mapX': mapX,
        'mapY': mapY,
        'distanceKm': distanceKm,
        'travelTime': travelTime,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBeach(String id) async {
    final db = await database;
    await db.delete(
      _tableBeaches,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
