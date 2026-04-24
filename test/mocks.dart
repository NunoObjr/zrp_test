import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:ricky_morty_list_char/modules/home/home_exports.dart';

@GenerateNiceMocks([
  MockSpec<RickAndMortyRepository>(),
  MockSpec<LoadEpisodeUsecase>(),
  MockSpec<LoadCharactersUsecase>(),
  MockSpec<RemoteDatasource>(),
  MockSpec<LocalDatasource>(),
  MockSpec<Dio>(),
])
void main() {}
