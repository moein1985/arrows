import 'package:flutter/material.dart';

class HudWidget extends StatelessWidget {
  final int levelNumber;
  final int totalLevels;
  final int hearts;
  final int maxHearts;
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onReset;
  final VoidCallback onHint;

  const HudWidget({
    super.key,
    required this.levelNumber,
    required this.totalLevels,
    required this.hearts,
    required this.maxHearts,
    required this.canUndo,
    required this.onUndo,
    required this.onReset,
    required this.onHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $levelNumber / $totalLevels',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: List.generate(maxHearts, (index) {
                final isAlive = index < hearts;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    isAlive ? Icons.favorite : Icons.favorite_border,
                    color: isAlive ? Colors.redAccent : Colors.white24,
                    size: 24,
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ActionButton(
              icon: Icons.undo,
              label: 'Undo',
              onTap: canUndo ? onUndo : null,
            ),
            _ActionButton(
              icon: Icons.refresh,
              label: 'Reset',
              onTap: onReset,
            ),
            _ActionButton(
              icon: Icons.lightbulb_outline,
              label: 'Hint',
              onTap: onHint,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF2A2A3E) : const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: enabled ? Colors.white : Colors.white24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.white24,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
