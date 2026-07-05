import 'package:flutter/material.dart';

class ProgressSummary extends StatelessWidget {
  final int currentLevel;
  final int totalLevels;

  const ProgressSummary({super.key, required this.currentLevel, required this.totalLevels});

  @override
  Widget build(BuildContext context) {
    final progress = (currentLevel / totalLevels).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'پیشرفت: $currentLevel از $totalLevels',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
        ),
      ],
    );
  }
}
