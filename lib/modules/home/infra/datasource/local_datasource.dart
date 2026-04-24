import '../model/episode.dart';
import '../model/rick_and_morty_characters.dart';

abstract class LocalDatasource {
  Future<void> insertEpisode(Episode episode);
  Future<Episode?> getEpisode(int id);
  
  Future<void> saveCharacters(List<RickAndMortyCharacter> characters, int episodeId);
  Future<List<RickAndMortyCharacter>> getCharactersByEpisode(int episodeId);
}
