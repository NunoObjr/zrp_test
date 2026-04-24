// coverage:ignore-file
import '../../domain/entities/episode_entity.dart';

class Episode extends EpisodeEntity {
  const Episode({
    required super.id,
    required super.name,
    required super.airDate,
    required super.episode,
    required super.characters,
    required super.url,
    required super.created,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      airDate: json['air_date'],
      episode: json['episode'],
      characters: List<String>.from(
        json['characters'],
      ),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': episode,
      'characters': characters,
      'url': url,
      'created': created.toIso8601String(),
    };
  }
}
