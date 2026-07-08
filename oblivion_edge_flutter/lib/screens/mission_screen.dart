import 'package:flutter/material.dart';
import '../theme/oblivion_theme.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({Key? key}) : super(key: key);

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final missions = [
    {
      'id': 'mission_1',
      'name': 'Welcome to Kepler-7b',
      'difficulty': 'Easy',
      'description': 'Navigate through asteroid field to colony beacon',
      'character': 'Command (Starlord)',
      'briefing':
          'Welcome to Kepler-7b, pilot. We\'ve got bandits in the asteroid field. Don\'t die—paperwork is a nightmare.',
      'facts': [
        'Kepler-7b orbits sun-like star every 4.89 days',
        '1,500 light-years from Earth',
        'Super-Earth/mini-Neptune: 1.5x Earth radius',
        'Surface temp ~427°C'
      ],
      'reward': 500,
    },
    {
      'id': 'mission_2',
      'name': 'Solar Storm Defense',
      'difficulty': 'Medium',
      'description': 'Protect satellites during coronal mass ejection',
      'character': 'Rocket (Sarcastic AI)',
      'briefing':
          'The sun\'s throwing a tantrum. Shield the satellites or we\'re all fried. Also, thanks for not crashing last time.',
      'facts': [
        'CMEs release 10^24 joules of energy',
        'That\'s 240 megatons per CME',
        'Earth\'s magnetosphere protects us',
        'Kepler-7b might not be so lucky'
      ],
      'reward': 750,
    },
    {
      'id': 'mission_3',
      'name': 'Meteor Shower Protocol',
      'difficulty': 'Medium',
      'description': 'Navigate through meteoroid stream safely',
      'character': 'Gamora (Serious Pilot)',
      'briefing':
          'Focus. Precision. We lose the colony, we lose everything. Fly like your life depends on it—because it does.',
      'facts': [
        'Meteoroid swarms from asteroid belts',
        'Impact speed: 11-72 km/s',
        'Crater formation depends on angle & composition',
        'Atmospheric friction slows smaller meteoroids'
      ],
      'reward': 1000,
    },
    {
      'id': 'mission_4',
      'name': 'Event Horizon Approach',
      'difficulty': 'Hard',
      'description': 'Collect data near black hole (DON\'T DIE!)',
      'character': 'Drax (Blunt & Honest)',
      'briefing':
          'Black hole. Dangerous. Obey laws of physics or die instantly. I am not being poetic, this is literal.',
      'facts': [
        'Event horizons: point of no return',
        'Tidal forces cause spaghettification',
        'Binary systems with black holes are X-ray sources',
        'Hawking radiation: tiny holes evaporate'
      ],
      'reward': 1500,
    },
    {
      'id': 'mission_5',
      'name': 'The Oblivion Event',
      'difficulty': 'Legendary',
      'description': 'Defeat rogue AI threatening Kepler-7b',
      'character': 'Yondu (Mysterious Mentor)',
      'briefing':
          'You\'ve come far, kid. Now it\'s time to end this. Fly true. Fly like you\'ve never flown before. Make \'em proud up there.',
      'facts': [
        'Over 5,000 exoplanets confirmed',
        'Habitable zones: between too hot and too cold',
        'Kepler telescope: named after Johannes Kepler',
        'AI safety: critical for civilization'
      ],
      'reward': 3000,
    },
  ];

  int selectedMission = 0;

  @override
  Widget build(BuildContext context) {
    final mission = missions[selectedMission];

    return Scaffold(
      backgroundColor: OblivionTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('MISSION SELECT'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mission List (Horizontal scroll)
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: missions.length,
                itemBuilder: (context, index) {
                  final m = missions[index];
                  final isSelected = index == selectedMission;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMission = index),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? OblivionTheme.primaryCyan
                              : OblivionTheme.secondaryGold,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? Colors.black54
                            : Colors.black.withOpacity(0.3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'M${index + 1}',
                            style: TextStyle(
                              color: isSelected
                                  ? OblivionTheme.primaryCyan
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            m['difficulty'] as String,
                            style: TextStyle(
                              color: _getDifficultyColor(m['difficulty'] as String),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Mission Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Difficulty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mission['name'] as String,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            mission['description'] as String,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(mission['difficulty'] as String)
                              .withOpacity(0.2),
                          border: Border.all(
                            color: _getDifficultyColor(mission['difficulty'] as String),
                          ),
                        ),
                        child: Text(
                          mission['difficulty'] as String,
                          style: TextStyle(
                            color:
                                _getDifficultyColor(mission['difficulty'] as String),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Character Briefing
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: OblivionTheme.primaryCyan),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black45,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (mission['character'] as String).toUpperCase(),
                          style: const TextStyle(
                            color: OblivionTheme.secondaryGold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mission['briefing'] as String,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Educational Facts
                  Text(
                    '📚 EDUCATIONAL FACTS',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: OblivionTheme.primaryCyan,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...(mission['facts'] as List<String>).map(
                    (fact) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🔬 ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Expanded(
                            child: Text(
                              fact,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Reward & Launch Button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: OblivionTheme.secondaryGold,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'REWARD',
                                style: TextStyle(
                                  color: OblivionTheme.primaryCyan,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '${mission['reward']} PTS',
                                style: const TextStyle(
                                  color: OblivionTheme.secondaryGold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/game');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: OblivionTheme.primaryCyan,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'LAUNCH MISSION',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return OblivionTheme.secondaryGold;
      case 'hard':
        return const Color(0xFFFF6B35);
      case 'legendary':
        return const Color(0xFFFF1493);
      default:
        return Colors.white;
    }
  }
}
