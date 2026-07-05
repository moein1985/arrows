import 'package:equatable/equatable.dart';

enum ArrowDirection { up, down, left, right }

class Arrow extends Equatable {
  final String id;
  final int row;
  final int col;
  final ArrowDirection direction;

  const Arrow({
    required this.id,
    required this.row,
    required this.col,
    required this.direction,
  });

  @override
  List<Object?> get props => [id, row, col, direction];
}
