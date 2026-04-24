import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

import '../mocks.mocks.dart';

void main() {
  late LoadEpisodeUsecase usecase;
  late MockRickAndMortyRepository mockRepository;

  setUp(() {
    mockRepository = MockRickAndMortyRepository();
    usecase = LoadEpisodeUsecase(mockRepository);
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

  test('should get episode from repository', () async {
    // arrange
    when(mockRepository.getEpisode('1')).thenAnswer((_) async => Right(tEpisode));

    // act
    final result = await usecase('1');

    // assert
    expect(result, equals(Right(tEpisode)));
    verify(mockRepository.getEpisode('1'));
    verifyNoMoreInteractions(mockRepository);
  });
}
