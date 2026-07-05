import 'package:equatable/equatable.dart';

enum ArrowDirection { up, down, left, right }

enum BlockState { idle, moving, exited, collided }

class Arrow extends Equatable {
  final String id;
  final int row;
  final int col;
  final ArrowDirection direction;
  final BlockState state;

  const Arrow({
    required this.id,
    required this.row,
    required this.col,
    required this.direction,
    this.state = BlockState.idle,
  });

  Arrow copyWith({BlockState? state}) {
    return Arrow(
      id: id,
      row: row,
      col: col,
      direction: direction,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [id, row, col, direction, state];
}
