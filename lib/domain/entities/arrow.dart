import 'package:equatable/equatable.dart';

enum ArrowDirection { up, down, left, right }

class Arrow extends Equatable {
  final String id;
  final ArrowDirection direction;

  const Arrow({required this.id, required this.direction});

  @override
  List<Object?> get props => [id, direction];
}
