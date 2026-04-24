// coverage:ignore-file
import 'package:get_it/get_it.dart';
import '../../modules/home/home_exports.dart';

final getIt = GetIt.instance;

void setupInjections() {
  // Data Sources
  getIt.registerLazySingleton<LocalDatasource>(() => LocalDatabase());
  getIt.registerLazySingleton<RemoteDatasource>(() => Service());

  // Repository
  getIt.registerLazySingleton<RickAndMortyRepository>(
    () => RickAndMortyRepositoryImpl(
      getIt<RemoteDatasource>(),
      getIt<LocalDatasource>(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton<LoadEpisodeUsecase>(
    () => LoadEpisodeUsecase(getIt<RickAndMortyRepository>()),
  );
  getIt.registerLazySingleton<LoadCharactersUsecase>(
    () => LoadCharactersUsecase(getIt<RickAndMortyRepository>()),
  );

  // Controller
  getIt.registerFactory<HomeController>(
    () => HomeController(
      getIt<LoadEpisodeUsecase>(),
      getIt<LoadCharactersUsecase>(),
    ),
  );
}
