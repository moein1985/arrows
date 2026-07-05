import 'package:equatable/equatable.dart';
import 'arrow.dart';

class GameLevel extends Equatable {
  final int id;
  final int gridRows;
  final int gridCols;
  final List<Arrow> arrows;
  final int hearts;
  final int difficulty;

  const GameLevel({
    required this.id,
    required this.gridRows,
    required this.gridCols,
    required this.arrows,
    required this.hearts,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [id, gridRows, gridCols, arrows, hearts, difficulty];
}
