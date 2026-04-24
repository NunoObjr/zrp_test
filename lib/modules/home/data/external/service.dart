import 'package:dio/dio.dart';
import '../../infra/datasource/remote_datasource.dart';
import '../../infra/model/episode.dart';
import '../../infra/model/rick_and_morty_characters.dart';

class Service implements RemoteDatasource {
  final Dio dio;

  Service({Dio? dio}) : dio = dio ?? Dio();

  @override
  Future<Episode> fetchEpisode(String episode) async {
    try {
      final response =
          await dio.get('https://rickandmortyapi.com/api/episode/$episode');
      return Episode.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  Future<List<RickAndMortyCharacter>> fetchCharacters(
      List<int> characterIds) async {
    try {
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character/${characterIds.join(',')}',
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((json) => RickAndMortyCharacter.fromJson(json))
            .toList();
      } else if (data is Map<String, dynamic>) {
        return [RickAndMortyCharacter.fromJson(data)];
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      throw Exception('Failed to fetch characters: $e');
    }
  }
}
