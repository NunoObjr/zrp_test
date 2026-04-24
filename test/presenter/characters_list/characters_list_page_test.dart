import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

void main() {
  group('CharactersListPage', () {
    late List<CharacterEntity> characters;
    final tCharacter1 = RickAndMortyCharacter(
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
    final tCharacter2 = RickAndMortyCharacter(
      id: 2,
      name: 'Morty Smith',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
      episode: const ['https://rickandmortyapi.com/api/episode/1'],
      url: 'https://rickandmortyapi.com/api/character/2',
      created: DateTime.parse('2017-11-04T18:48:46.250Z'),
    );
    final tCharacter3 = RickAndMortyCharacter(
      id: 183,
      name: 'Johnny Depp',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      image: 'https://rickandmortyapi.com/api/character/avatar/183.jpeg',
      episode: const ['https://rickandmortyapi.com/api/episode/8'],
      url: 'https://rickandmortyapi.com/api/character/183',
      created: DateTime.parse('2017-12-29T18:51:29.693Z'),
    );
    setUp(() {
      characters = [
        tCharacter1,
        tCharacter2,
        tCharacter3,
      ];
    });

    Widget createWidgetUnderTest() {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => CharactersListPage(
              characters: characters,
            ),
          ),
        ],
      );

      return MaterialApp.router(
        routerConfig: router,
      );
    }

    testWidgets(
      'deve renderizar appBar com título corretamente',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Lista de personagens'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      },
    );

    testWidgets(
      'deve renderizar lista de personagens',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Rick Sanchez'), findsOneWidget);
        expect(find.text('Johnny Depp'), findsOneWidget);
        expect(find.text('Morty Smith'), findsOneWidget);

        expect(find.text('Human'), findsNWidgets(3));
        expect(find.byType(ListTile), findsNWidgets(3));
      },
    );

    testWidgets(
      'deve ordenar personagens por nome em ordem alfabética',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final johnnyFinder = find.text('Johnny Depp');
        final mortyFinder = find.text('Morty Smith');
        final rickFinder = find.text('Rick Sanchez');

        expect(johnnyFinder, findsOneWidget);
        expect(mortyFinder, findsOneWidget);
        expect(rickFinder, findsOneWidget);

        final johnnyPosition = tester.getTopLeft(johnnyFinder).dy;
        final mortyPosition = tester.getTopLeft(mortyFinder).dy;
        final rickPosition = tester.getTopLeft(rickFinder).dy;

        expect(johnnyPosition < mortyPosition, true);
        expect(mortyPosition < rickPosition, true);
      },
    );

    testWidgets(
      'deve renderizar Image.network para cada personagem',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(Image), findsNWidgets(3));
      },
    );

    testWidgets(
      'deve renderizar ícone de erro quando imagem falhar',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error), findsWidgets);
      },
    );
  });
}
