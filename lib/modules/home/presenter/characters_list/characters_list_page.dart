import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/character_entity.dart';
import 'package:shimmer/shimmer.dart';

class CharactersListPage extends StatelessWidget {
  const CharactersListPage({super.key, required this.characters});

  final List<CharacterEntity> characters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de personagens'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final sortedCharacters = List<CharacterEntity>.from(characters);
            sortedCharacters.sort((a, b) => a.name.compareTo(b.name));
            final character = sortedCharacters[index];
            return _CharacterDetail(character: character);
          },
        ),
      ),
    );
  }
}

class _CharacterDetail extends StatelessWidget {
  const _CharacterDetail({required this.character});
  final CharacterEntity character;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(character.name),
      subtitle: Text(character.species),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 50,
          height: 50,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
        ),
      ),
    );
  }
}
