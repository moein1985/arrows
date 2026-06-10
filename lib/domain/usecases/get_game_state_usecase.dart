import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/game_state.dart';
import '../repositories/game_repository.dart';

abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

class GetGameStateUseCase extends StreamUseCase<GameState, NoParams> {
  final GameRepository repository;

  GetGameStateUseCase(this.repository);

  @override
  Stream<Either<Failure, GameState>> call(NoParams params) {
    return repository.getGameState();
  }
}
