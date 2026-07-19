import 'package:flutter/material.dart';
import '../theme/oblivion_theme.dart';

class SigintHud extends StatelessWidget {
  final double signalStrength;
  final int interceptedCount;
  final int targetCount;

  const SigintHud({
    Key? key,
    required this.signalStrength,
    required this.interceptedCount,
    required this.targetCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: OblivionTheme.secondaryGold),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'SIGINT COLLECTION',
            style: TextStyle(
              color: OblivionTheme.secondaryGold,
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
                'SIGNAL: ',
                style: TextStyle(
                  color: OblivionTheme.primaryCyan,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                '${(signalStrength * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: signalStrength > 0.7
                      ? OblivionTheme.neonGreen
                      : signalStrength > 0.3
                          ? OblivionTheme.secondaryGold
                          : OblivionTheme.orangeAccent,
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
                value: signalStrength.clamp(0.0, 1.0),
                backgroundColor: OblivionTheme.darkGray,
                valueColor: AlwaysStoppedAnimation<Color>(
                  signalStrength > 0.7
                      ? OblivionTheme.neonGreen
                      : OblivionTheme.secondaryGold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'INTERCEPTS: $interceptedCount / $targetCount',
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
