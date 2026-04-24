import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ricky_morty_list_char/core/error/failure.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

import '../../mocks.mocks.dart';

void main() {
  late RickAndMortyRepositoryImpl repository;
  late MockRemoteDatasource mockRemoteDatasource;
  late MockLocalDatasource mockLocalDatasource;

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    repository =
        RickAndMortyRepositoryImpl(mockRemoteDatasource, mockLocalDatasource);
  });

  final tEpisode = Episode(
    id: 1,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episode: 'S01E01',
    characters: const ['https://rickandmortyapi.com/api/character/1'],
    url: 'https://rickandmortyapi.com/api/episode/1',
    created: DateTime.parse('2017-11-10T12:56:33.798Z'),
  );

  final tCharacter = RickAndMortyCharacter(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    episode: const ['https://rickandmortyapi.com/api/episode/1'],
    url: 'https://rickandmortyapi.com/api/character/1',
    created: DateTime.parse('2017-11-04T18:48:46.250Z'),
  );

  group('getEpisode', () {
    test('should return cached episode when it exists in database', () async {
      // arrange
      when(mockLocalDatasource.getEpisode(1)).thenAnswer((_) async => tEpisode);

      // act
      final result = await repository.getEpisode('1');

      // assert
      expect(result, equals(Right<Failure, EpisodeEntity>(tEpisode)));
      verify(mockLocalDatasource.getEpisode(1));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should fetch from service and save to database when not in cache',
        () async {
      // arrange
      when(mockLocalDatasource.getEpisode(1)).thenAnswer((_) async => null);
      when(mockRemoteDatasource.fetchEpisode('1'))
          .thenAnswer((_) async => tEpisode);

      // act
      final result = await repository.getEpisode('1');

      // assert
      expect(result, equals(Right<Failure, EpisodeEntity>(tEpisode)));
      verify(mockLocalDatasource.getEpisode(1));
      verify(mockRemoteDatasource.fetchEpisode('1'));
      verify(mockLocalDatasource.insertEpisode(tEpisode));
    });
  });

  group('getCharacters', () {
    final tCharacterUrls = ['https://rickandmortyapi.com/api/character/1'];

    test('should return cached characters when they exist in database',
        () async {
      // arrange
      when(mockLocalDatasource.getCharactersByEpisode(1))
          .thenAnswer((_) async => [tCharacter]);

      // act
      final result = await repository.getCharacters(1, tCharacterUrls);

      // assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), equals([tCharacter]));
      verify(mockLocalDatasource.getCharactersByEpisode(1));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should fetch from remote and save to database when not in cache',
        () async {
      // arrange
      when(mockLocalDatasource.getCharactersByEpisode(1))
          .thenAnswer((_) async => []);
      when(mockRemoteDatasource.fetchCharacters([1]))
          .thenAnswer((_) async => [tCharacter]);

      // act
      final result = await repository.getCharacters(1, tCharacterUrls);

      // assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), equals([tCharacter]));
      verify(mockLocalDatasource.getCharactersByEpisode(1));
      verify(mockRemoteDatasource.fetchCharacters([1]));
      verify(mockLocalDatasource.saveCharacters([tCharacter], 1));
    });
  });
}
