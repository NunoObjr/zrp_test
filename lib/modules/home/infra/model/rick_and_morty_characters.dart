// coverage:ignore-file
import '../../domain/entities/character_entity.dart';

class RickAndMortyCharacter extends CharacterEntity {
  const RickAndMortyCharacter({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.image,
    required super.episode,
    required super.url,
    required super.created,
  });

  factory RickAndMortyCharacter.fromJson(Map<String, dynamic> json) {
    return RickAndMortyCharacter(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      image: json['image'],
      episode: List<String>.from(json['episode']),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'episode': episode,
      'url': url,
      'created': created.toIso8601String(),
    };
  }
}
