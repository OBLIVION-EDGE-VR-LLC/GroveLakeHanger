import '../models/mission_data.dart';

/// Converts MissionData to the legacy Map<String, dynamic> format
/// used by the existing MissionScreen widget.
class MissionAdapter {
  static Map<String, dynamic> toLegacyMap(MissionData mission) {
    // Use first phase's briefing and character for legacy display
    final firstPhase = mission.phases.isNotEmpty ? mission.phases[0] : null;

    // Combine all educational content for legacy facts display
    final allFacts = <String>[
      ...mission.educationalFacts,
      ...mission.phases.expand((p) => p.educationalContent),
    ];

    return {
      'id': mission.id,
      'name': mission.name,
      'difficulty': mission.difficulty[0].toUpperCase() +
          mission.difficulty.substring(1),
      'description': mission.description,
      'character': firstPhase?.character ?? 'Unknown',
      'briefing': firstPhase?.briefing ?? '',
      'facts': allFacts,
      'reward': mission.reward,
      'isMissionData': true,
    };
  }
}
