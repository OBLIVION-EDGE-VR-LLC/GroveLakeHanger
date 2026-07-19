import 'package:flutter/material.dart';
import '../theme/oblivion_theme.dart';
import 'craft_selection_screen.dart';
import 'mission_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OblivionTheme.darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo/Title
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: OblivionTheme.primaryCyan,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'OBLIVION EDGE',
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Flight Simulator',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Start Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CraftSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    backgroundColor: OblivionTheme.primaryCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'START MISSION',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: OblivionTheme.darkBackground,
                          fontSize: 16,
                        ),
                  ),
                ),
                const SizedBox(height: 16),

                // Missions Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MissionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    backgroundColor: OblivionTheme.secondaryGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'MISSIONS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: OblivionTheme.darkBackground,
                          fontSize: 16,
                        ),
                  ),
                ),
                const SizedBox(height: 16),

                // Settings Button
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings coming soon')),
                    );
                  },
                  child: Text(
                    'SETTINGS',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 16),

                // About Button
                OutlinedButton(
                  onPressed: () {
                    _showAboutDialog(context);
                  },
                  child: Text(
                    'ABOUT',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 48),

                // Footer
                Text(
                  'Vulnerability Research LLC',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: OblivionTheme.darkGray,
        title: Text(
          'About',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          'Oblivion Edge: Flight Simulator\n\n'
          'Test experimental craft over the Nevada desert near Grove Lake — '
          'a classified flight testing range where advanced aerospace programs '
          'push the boundaries of physics.\n\n'
          'Select from unique craft with distinct physics-based flight characteristics. '
          'Master the controls with dual joystick touch input.\n\n'
          'Made with Flutter and Three.js.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
