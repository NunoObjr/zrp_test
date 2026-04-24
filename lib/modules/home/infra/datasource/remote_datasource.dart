import '../model/episode.dart';
import '../model/rick_and_morty_characters.dart';

abstract class RemoteDatasource {
  Future<Episode> fetchEpisode(String episodeNumber);
  Future<List<RickAndMortyCharacter>> fetchCharacters(List<int> characterIds);
}
