import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/arrow.dart';
import '../repositories/game_repository.dart';

class SubmitPlayerActionUseCase extends UseCase<void, Params> {
  final GameRepository repository;

  SubmitPlayerActionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.submitPlayerAction(params.direction);
  }
}

class Params extends Equatable {
  final ArrowDirection direction;

  const Params({required this.direction});

  @override
  List<Object> get props => [direction];
}
