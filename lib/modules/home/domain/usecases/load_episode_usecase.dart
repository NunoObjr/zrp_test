import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/episode_entity.dart';
import '../repositories/rick_and_morty_repository.dart';

class LoadEpisodeUsecase {
  final RickAndMortyRepository _repository;

  LoadEpisodeUsecase(this._repository);

  Future<Either<Failure, EpisodeEntity>> call(String episodeNumber) {
    return _repository.getEpisode(episodeNumber);
  }
}
