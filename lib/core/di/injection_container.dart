import 'package:get_it/get_it.dart';
import '../../data/datasources/game_local_data_source.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/usecases/get_game_state_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';
import '../../domain/usecases/submit_player_action_usecase.dart';
import '../../presentation/state/bloc/game_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => GameBloc(
      startGameUseCase: sl(),
      getGameStateUseCase: sl(),
      submitPlayerActionUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => StartGameUseCase(sl()));
  sl.registerLazySingleton(() => GetGameStateUseCase(sl()));
  sl.registerLazySingleton(() => SubmitPlayerActionUseCase(sl()));

  // Repository
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<GameLocalDataSource>(
    () => GameLocalDataSourceImpl(),
  );
}
