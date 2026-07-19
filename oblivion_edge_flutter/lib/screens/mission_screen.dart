import 'package:flutter/material.dart';
import '../theme/oblivion_theme.dart';
import '../models/mission_data.dart';
import '../missions/mission_adapter.dart';
import 'mission_detail_screen.dart';
import 'game_screen.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({Key? key}) : super(key: key);

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late final List<Map<String, dynamic>> missions;
  int selectedMission = 0;

  @override
  void initState() {
    super.initState();
    missions = [
      {
        'id': 'mission_1',
        'name': 'Welcome to Grove Lake',
        'difficulty': 'Easy',
        'description': 'First flight over the Nevada desert test range',
        'character': 'Control (Handler)',
        'briefing':
            'Welcome to Grove Lake, pilot. Beautiful day for a first flight over the desert. Let\'s see what you\'ve got\u2014don\'t scratch the paint.',
        'facts': [
          'Nevada Test and Training Range: 4,531 sq miles of restricted airspace',
          'Groom Lake dry lakebed: natural runway 7 miles long',
          'First stealth aircraft tested in Nevada deserts in the 1970s',
          'Desert thermals can create turbulence up to 15,000 ft AGL'
        ],
        'reward': 500,
      },
      {
        'id': 'mission_2',
        'name': 'Canyon Run',
        'difficulty': 'Medium',
        'description': 'Navigate desert canyons at low altitude',
        'character': 'Control (Handler)',
        'briefing':
            'Morning, pilot. Today we push harder. Those canyon waypoints aren\'t optional\u2014precision matters. Sloppy flying gets people killed.',
        'facts': [
          'Terrain-following radar allows flight below 200 ft AGL',
          'Red Flag exercises train pilots in realistic combat scenarios',
          'Nevada\'s Basin and Range topology creates natural radar shadows',
          'Low-altitude flight requires constant energy management'
        ],
        'reward': 750,
      },
      {
        'id': 'mission_3',
        'name': 'The Recruitment',
        'difficulty': 'Medium',
        'description': 'Night ops \u2014 classified facility reconnaissance',
        'character': 'Control (Handler)',
        'briefing':
            'This is off the books. No flight plan, no radio log. There\'s a beacon north\u2014classified. Fly there and back. Questions later.',
        'facts': [
          'Night vision goggles amplify light 30,000-50,000 times',
          'IR signature management is critical for stealth aircraft',
          'Restricted airspace (R-4808N) surrounds the most classified test sites',
          'Radar cross-section of the F-117 was smaller than a marble'
        ],
        'reward': 1000,
      },
      {
        'id': 'mission_4',
        'name': 'Ceiling Test',
        'difficulty': 'Hard',
        'description': 'Push experimental craft to maximum altitude',
        'character': 'Control (Handler)',
        'briefing':
            'We need performance data at the edge of the envelope. Take her up\u2014as high as she\'ll go. If the hull starts singing, back off.',
        'facts': [
          'SR-71 Blackbird cruised above 85,000 ft at Mach 3.2',
          'Above 63,000 ft (Armstrong line) blood boils without pressurization',
          'X-15 rocket plane reached 354,200 ft \u2014 the edge of space',
          'Plasma heating at hypersonic speeds exceeds 1,000\u00b0F'
        ],
        'reward': 1500,
      },
      {
        'id': 'mission_5',
        'name': 'The Oblivion Protocol',
        'difficulty': 'Legendary',
        'description': 'Final classified operation over Grove Lake',
        'character': 'Control (Handler)',
        'briefing':
            'You\'ve come far, kid. This is the one they\'ll never talk about. Fly true. Fly like you\'ve never flown before. Make the program proud.',
        'facts': [
          'Over 60 years of classified aircraft tested in Nevada',
          'Have Blue prototype proved stealth was achievable in 1977',
          'Lockheed Skunk Works motto: "Quick, Quiet, Quality"',
          'The best test pilots trust their instruments over their instincts'
        ],
        'reward': 3000,
      },
      // New MissionData missions via adapter
      ...MissionData.allMissions.map((m) => MissionAdapter.toLegacyMap(m)),
    ];
  }

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
                            final m = missions[selectedMission];
                            if (m['isMissionData'] == true) {
                              final missionData = MissionData.allMissions
                                  .firstWhere((md) => md.id == m['id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MissionDetailScreen(mission: missionData),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameScreen(missionId: selectedMission + 1),
                                ),
                              );
                            }
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
