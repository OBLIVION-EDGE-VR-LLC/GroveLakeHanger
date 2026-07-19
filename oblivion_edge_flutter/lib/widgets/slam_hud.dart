import 'package:flutter/material.dart';
import '../theme/oblivion_theme.dart';

class SlamHud extends StatelessWidget {
  final double coverage;
  final int waypointsRemaining;

  const SlamHud({
    Key? key,
    required this.coverage,
    required this.waypointsRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: OblivionTheme.primaryCyan),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'SLAM MAPPING',
            style: TextStyle(
              color: OblivionTheme.primaryCyan,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'COVERAGE: ',
                style: TextStyle(
                  color: OblivionTheme.primaryCyan,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                '${(coverage * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: OblivionTheme.secondaryGold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 120,
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: coverage.clamp(0.0, 1.0),
                backgroundColor: OblivionTheme.darkGray,
                valueColor: AlwaysStoppedAnimation<Color>(
                  coverage >= 1.0
                      ? OblivionTheme.neonGreen
                      : OblivionTheme.primaryCyan,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'WAYPOINTS: $waypointsRemaining remaining',
            style: const TextStyle(
              color: OblivionTheme.lightGray,
              fontSize: 9,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
