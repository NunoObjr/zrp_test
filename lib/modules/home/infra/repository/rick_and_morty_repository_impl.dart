import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/entities/episode_entity.dart';
import '../../domain/repositories/rick_and_morty_repository.dart';
import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class RickAndMortyRepositoryImpl implements RickAndMortyRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;

  RickAndMortyRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<Failure, EpisodeEntity>> getEpisode(
      String episodeNumber) async {
    final id = int.tryParse(episodeNumber);
    if (id != null) {
      try {
        final cachedEpisode = await _localDatasource.getEpisode(id);
        if (cachedEpisode != null) {
          return Right(cachedEpisode);
        }
      } catch (e) {
        debugPrint('Local fetch episode failed: $e');
      }
    }

    try {
      final episode = await _remoteDatasource.fetchEpisode(episodeNumber);
      await _localDatasource.insertEpisode(episode);
      return Right(episode);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CharacterEntity>>> getCharacters(
      int episodeId, List<String> characterUrls) async {
    try {
      final cachedCharacters =
          await _localDatasource.getCharactersByEpisode(episodeId);
      if (cachedCharacters.isNotEmpty &&
          cachedCharacters.length == characterUrls.length) {
        return Right(cachedCharacters);
      }
    } catch (e) {
      debugPrint('Local fetch characters failed: $e');
    }

    try {
      final ids =
          characterUrls.map((url) => int.parse(url.split('/').last)).toList();
      final characters = await _remoteDatasource.fetchCharacters(ids);
      await _localDatasource.saveCharacters(characters, episodeId);
      return Right(characters);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
