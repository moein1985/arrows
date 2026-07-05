import 'package:flutter/material.dart';
import '../../../domain/entities/arrow.dart';

class ArrowWidget extends StatelessWidget {
  final Arrow? arrow;
  final bool isHint;
  final bool isCollision;
  final VoidCallback? onTap;

  const ArrowWidget({
    super.key,
    this.arrow,
    this.isHint = false,
    this.isCollision = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFF1E1E2E);
    Color iconColor = Colors.white;

    if (arrow == null) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xFF151521),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    if (isHint) {
      bgColor = Colors.green.withValues(alpha: 0.3);
      iconColor = Colors.greenAccent;
    } else if (isCollision) {
      bgColor = Colors.red.withValues(alpha: 0.3);
      iconColor = Colors.redAccent;
    }

    IconData iconData;
    switch (arrow!.direction) {
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

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: isHint
              ? Border.all(color: Colors.greenAccent, width: 2)
              : null,
        ),
        child: Icon(iconData, size: 32, color: iconColor),
      ),
    );
  }
}
