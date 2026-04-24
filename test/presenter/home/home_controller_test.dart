import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ricky_morty_list_char/core/error/failure.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

import '../../mocks.mocks.dart';

void main() {
  late HomeController controller;
  late MockLoadEpisodeUsecase mockLoadEpisodeUsecase;
  late MockLoadCharactersUsecase mockLoadCharactersUsecase;

  setUp(() {
    mockLoadEpisodeUsecase = MockLoadEpisodeUsecase();
    mockLoadCharactersUsecase = MockLoadCharactersUsecase();
    controller = HomeController(
      mockLoadEpisodeUsecase,
      mockLoadCharactersUsecase,
    );
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

  test('should set isLoading to true and fetch episode and characters',
      () async {
    // arrange
    when(mockLoadEpisodeUsecase('1')).thenAnswer((_) async => Right(tEpisode));
    when(mockLoadCharactersUsecase(1, tEpisode.characters))
        .thenAnswer((_) async => Right([tCharacter]));

    // act
    final future = controller.searchEpisode('1');

    // assert - check loading state during execution
    expect(controller.isLoading, true);

    await future;

    expect(controller.episode, equals(tEpisode));
    expect(controller.characters, equals([tCharacter]));
    expect(controller.isLoading, false);
    verify(mockLoadEpisodeUsecase('1'));
    verify(mockLoadCharactersUsecase(1, tEpisode.characters));
  });

  test('should set isLoading to false even if failure occurs', () async {
    // arrange
    when(mockLoadEpisodeUsecase('1'))
        .thenAnswer((_) async => const Left(ServerFailure('error')));

    // act
    await controller.searchEpisode('1');

    // assert
    expect(controller.isLoading, false);
    expect(controller.errorMessage, equals('error'));
  });
}
