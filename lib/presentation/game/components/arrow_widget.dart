import 'package:flutter/material.dart';
import '../../../domain/entities/arrow.dart';

class ArrowWidget extends StatelessWidget {
  final Arrow arrow;

  const ArrowWidget({super.key, required this.arrow});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (arrow.direction) {
      case ArrowDirection.up:
        iconData = Icons.arrow_upward;
        break;
      case ArrowDirection.down:
        iconData = Icons.arrow_downward;
        break;
      case ArrowDirection.left:
        iconData = Icons.arrow_back;
        break;
      case ArrowDirection.right:
        iconData = Icons.arrow_forward;
        break;
    }
    return Icon(iconData, size: 50, color: Colors.white);
  }
}
