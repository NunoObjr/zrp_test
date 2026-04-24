import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ricky_morty_list_char/modules/home/data/external/service.dart';
import 'package:ricky_morty_list_char/modules/home/infra/model/episode.dart';
import 'package:ricky_morty_list_char/modules/home/infra/model/rick_and_morty_characters.dart';

import '../../mocks.mocks.dart';

void main() {
  late Service service;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    service = Service(dio: mockDio);
  });

  group('Service - fetchEpisode', () {
    const episodeId = '1';
    final episodeJson = {
      'id': 1,
      'name': 'Pilot',
      'air_date': 'December 2, 2013',
      'episode': 'S01E01',
      'characters': ['https://rickandmortyapi.com/api/character/1'],
      'url': 'https://rickandmortyapi.com/api/episode/1',
      'created': '2017-11-10T12:56:33.798Z',
    };

    test('should return an Episode when the call to dio is successful', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: episodeJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await service.fetchEpisode(episodeId);

      expect(result, isA<Episode>());
      expect(result.id, 1);
      expect(result.name, 'Pilot');
    });

    test('should throw an Exception when the call to dio fails', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Error',
      ));

      expect(() => service.fetchEpisode(episodeId), throwsException);
    });
  });

  group('Service - fetchCharacters', () {
    final characterIds = [1, 2];
    final charactersJson = [
      {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        'episode': ['https://rickandmortyapi.com/api/episode/1'],
        'url': 'https://rickandmortyapi.com/api/character/1',
        'created': '2017-11-04T18:48:46.250Z',
      },
      {
        'id': 2,
        'name': 'Morty Smith',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'image': 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        'episode': ['https://rickandmortyapi.com/api/episode/1'],
        'url': 'https://rickandmortyapi.com/api/character/2',
        'created': '2017-11-04T18:50:21.651Z',
      }
    ];

    test('should return a list of RickAndMortyCharacter when the call to dio is successful with multiple ids', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: charactersJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await service.fetchCharacters(characterIds);

      expect(result, isA<List<RickAndMortyCharacter>>());
      expect(result.length, 2);
      expect(result[0].name, 'Rick Sanchez');
    });

    test('should return a list with one character when the call to dio returns a single object', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: charactersJson[0],
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await service.fetchCharacters([1]);

      expect(result, isA<List<RickAndMortyCharacter>>());
      expect(result.length, 1);
      expect(result[0].name, 'Rick Sanchez');
    });

    test('should throw an Exception when the call to dio returns unexpected format', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: 'invalid',
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(() => service.fetchCharacters(characterIds), throwsException);
    });

    test('should throw an Exception when the call to dio fails', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Error',
      ));

      expect(() => service.fetchCharacters(characterIds), throwsException);
    });
  });
}
