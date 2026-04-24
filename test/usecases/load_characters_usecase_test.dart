import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

import '../mocks.mocks.dart';

void main() {
  late LoadCharactersUsecase usecase;
  late MockRickAndMortyRepository mockRepository;

  setUp(() {
    mockRepository = MockRickAndMortyRepository();
    usecase = LoadCharactersUsecase(mockRepository);
  });

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

  test('should get characters from repository', () async {
    // arrange
    final tUrls = ['https://rickandmortyapi.com/api/character/1'];
    when(mockRepository.getCharacters(1, tUrls))
        .thenAnswer((_) async => Right([tCharacter]));

    // act
    final result = await usecase(1, tUrls);

    // assert
    expect(result.isRight(), true);
    expect(result.getOrElse(() => []), equals([tCharacter]));
    verify(mockRepository.getCharacters(1, tUrls));
    verifyNoMoreInteractions(mockRepository);
  });
}
