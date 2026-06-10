import 'package:dartz/dartz.dart';
import '../entities/game_state.dart';
import '../entities/arrow.dart';
import '../../core/error/failures.dart';

abstract class GameRepository {
  Stream<Either<Failure, GameState>> getGameState();
  Future<Either<Failure, void>> startGame();
  Future<Either<Failure, void>> submitPlayerAction(ArrowDirection direction);
}
