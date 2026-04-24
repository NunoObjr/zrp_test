import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/episode_entity.dart';
import '../entities/character_entity.dart';

abstract class RickAndMortyRepository {
  Future<Either<Failure, EpisodeEntity>> getEpisode(String episodeNumber);
  Future<Either<Failure, List<CharacterEntity>>> getCharacters(
      int episodeId, List<String> characterUrls);
}
