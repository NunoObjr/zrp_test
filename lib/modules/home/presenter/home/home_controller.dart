import 'package:flutter/material.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

class HomeController extends ChangeNotifier {
  final LoadEpisodeUsecase _loadEpisodeUsecase;
  final LoadCharactersUsecase _loadCharactersUsecase;

  HomeController(this._loadEpisodeUsecase, this._loadCharactersUsecase);

  List<CharacterEntity>? _characters;
  List<CharacterEntity> get characters => _characters ?? [];

  EpisodeEntity? _episode;
  EpisodeEntity? get episode => _episode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> searchEpisode(String episodeNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _loadEpisodeUsecase(episodeNumber);

    await result.fold(
      (failure) async {
        _errorMessage = failure.message;
        _episode = null;
        _characters = null;
      },
      (episodeEntity) async {
        _episode = episodeEntity;
        await _loadCharacters(episodeEntity.id);
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCharacters(int episodeId) async {
    if (_episode == null) return;

    final result =
        await _loadCharactersUsecase(episodeId, _episode!.characters);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _characters = null;
      },
      (charactersList) {
        _characters = charactersList;
      },
    );
  }
}
