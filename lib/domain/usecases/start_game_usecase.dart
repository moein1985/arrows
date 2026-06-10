import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/game_repository.dart';

class StartGameUseCase extends UseCase<void, NoParams> {
  final GameRepository repository;

  StartGameUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.startGame();
  }
}
