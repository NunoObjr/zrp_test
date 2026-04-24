import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ricky_morty_list_char/core/di/injection.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

void main() {
  setupInjections();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/episode-detail',
      builder: (context, state) {
        final characters = state.extra as List<CharacterEntity>;

        return CharactersListPage(
          characters: characters,
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rick and Morty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
