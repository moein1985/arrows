import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/arrow.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_data_source.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  @override
  Stream<Either<Failure, GameState>> getGameState() async* {
    try {
      await for (final gameState in localDataSource.getGameState()) {
        yield Right(gameState);
      }
    } catch (e) {
      yield Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> startGame() async {
    try {
      await localDataSource.startGame();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> submitPlayerAction(ArrowDirection direction) async {
    try {
      await localDataSource.submitPlayerAction(direction);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
