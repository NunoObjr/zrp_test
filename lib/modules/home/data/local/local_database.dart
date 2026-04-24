import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../infra/datasource/local_datasource.dart';
import '../../infra/model/episode.dart';
import '../../infra/model/rick_and_morty_characters.dart';

class LocalDatabase implements LocalDatasource {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  factory LocalDatabase() => _instance;

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'episodes.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE episodes(
            id INTEGER PRIMARY KEY,
            name TEXT,
            air_date TEXT,
            episode TEXT,
            characters TEXT,
            url TEXT,
            created TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE characters(
            id INTEGER PRIMARY KEY,
            name TEXT,
            status TEXT,
            species TEXT,
            type TEXT,
            gender TEXT,
            image TEXT,
            episode TEXT,
            url TEXT,
            created TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE episode_characters(
            episode_id INTEGER,
            character_id INTEGER,
            PRIMARY KEY (episode_id, character_id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE characters(
              id INTEGER PRIMARY KEY,
              name TEXT,
              status TEXT,
              species TEXT,
              type TEXT,
              gender TEXT,
              image TEXT,
              episode TEXT,
              url TEXT,
              created TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE episode_characters(
              episode_id INTEGER,
              character_id INTEGER,
              PRIMARY KEY (episode_id, character_id)
            )
          ''');
        }
      },
    );
  }

  @override
  Future<void> insertEpisode(Episode episode) async {
    try {
      final db = await database;
      final map = episode.toJson();
      map['characters'] = jsonEncode(map['characters']);
      await db.insert(
        'episodes',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error inserting episode into database: $e');
    }
  }

  @override
  Future<Episode?> getEpisode(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'episodes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = Map<String, dynamic>.from(maps.first);
      map['characters'] = jsonDecode(map['characters'] as String);
      return Episode.fromJson(map);
    }
    return null;
  }

  @override
  Future<void> saveCharacters(
      List<RickAndMortyCharacter> characters, int episodeId) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final char in characters) {
        final map = char.toJson();
        map['episode'] = jsonEncode(map['episode']);
        await txn.insert(
          'characters',
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await txn.insert(
          'episode_characters',
          {
            'episode_id': episodeId,
            'character_id': char.id,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }

  @override
  Future<List<RickAndMortyCharacter>> getCharactersByEpisode(
      int episodeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT c.* FROM characters c
      INNER JOIN episode_characters ec ON c.id = ec.character_id
      WHERE ec.episode_id = ?
    ''', [episodeId]);

    return maps.map((map) {
      final mutableMap = Map<String, dynamic>.from(map);
      mutableMap['episode'] = jsonDecode(mutableMap['episode'] as String);
      return RickAndMortyCharacter.fromJson(mutableMap);
    }).toList();
  }
}
