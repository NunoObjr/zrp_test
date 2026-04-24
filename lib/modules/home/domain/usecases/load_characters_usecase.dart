import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/character_entity.dart';
import '../repositories/rick_and_morty_repository.dart';

class LoadCharactersUsecase {
  final RickAndMortyRepository _repository;

  LoadCharactersUsecase(this._repository);

  Future<Either<Failure, List<CharacterEntity>>> call(int episodeId, List<String> characterUrls) {
    return _repository.getCharacters(episodeId, characterUrls);
  }
}
