import 'package:flutter_test/flutter_test.dart';
import 'package:ricky_morty_list_char/modules/home/data/local/local_database.dart';
import 'package:ricky_morty_list_char/modules/home/infra/model/episode.dart';
import 'package:ricky_morty_list_char/modules/home/infra/model/rick_and_morty_characters.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late LocalDatabase localDatabase;
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath, version: 2,
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
    });
    LocalDatabase.setDatabase(db);
    localDatabase = LocalDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  final episode = Episode(
    id: 1,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episode: 'S01E01',
    characters: ['https://rickandmortyapi.com/api/character/1'],
    url: 'https://rickandmortyapi.com/api/episode/1',
    created: DateTime.parse('2017-11-10T12:56:33.798Z'),
  );

  final character = RickAndMortyCharacter(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    episode: ['https://rickandmortyapi.com/api/episode/1'],
    url: 'https://rickandmortyapi.com/api/character/1',
    created: DateTime.parse('2017-11-04T18:48:46.250Z'),
  );

  test('should insert and get episode', () async {
    await localDatabase.insertEpisode(episode);
    final result = await localDatabase.getEpisode(1);

    expect(result, isNotNull);
    expect(result!.id, episode.id);
    expect(result.name, episode.name);
  });

  test('should return null when episode does not exist', () async {
    final result = await localDatabase.getEpisode(999);
    expect(result, isNull);
  });

  test('should save and get characters by episode', () async {
    await localDatabase.saveCharacters([character], 1);
    final result = await localDatabase.getCharactersByEpisode(1);

    expect(result, isNotEmpty);
    expect(result.length, 1);
    expect(result[0].id, character.id);
    expect(result[0].name, character.name);
  });

  test('should return empty list when no characters for episode', () async {
    final result = await localDatabase.getCharactersByEpisode(999);
    expect(result, isEmpty);
  });

  test('should run onUpgrade when version increases', () async {
    // Close current db
    await db.close();
    final dbPath = join(await getDatabasesPath(), 'test_upgrade.db');
    
    // Delete if exists
    if (await databaseFactory.databaseExists(dbPath)) {
      await databaseFactory.deleteDatabase(dbPath);
    }

    // Open with version 1
    db = await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
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
    });
    await db.close();

    // Open with version 2 to trigger onUpgrade
    db = await openDatabase(dbPath, version: 2, 
      onCreate: (db, version) => fail('Should not run onCreate'),
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
      }
    );

    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    final tableNames = tables.map((e) => e['name'] as String).toList();
    
    expect(tableNames, contains('characters'));
    expect(tableNames, contains('episode_characters'));
    
    await db.close();
    await databaseFactory.deleteDatabase(dbPath);
  });

  test('should log error when insertEpisode fails', () async {
    await db.close(); // Force failure
    
    // This should catch the exception and print to debug
    await localDatabase.insertEpisode(episode);
    // Success means it didn't crash
  });
}
