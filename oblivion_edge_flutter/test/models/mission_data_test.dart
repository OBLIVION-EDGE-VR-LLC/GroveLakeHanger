import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/models/mission_data.dart';
import 'package:oblivion_edge_flight/missions/mission_adapter.dart';

void main() {
  MissionData buildTestMission() {
    return MissionData(
      id: 'test_mission',
      name: 'Test Mission',
      description: 'A test',
      difficulty: 'medium',
      pathAffinity: ['patriot', 'grey'],
      storyAct: 'isr_sigint',
      skillRequirements: {'pilot': 3},
      reward: 1000,
      phases: [
        MissionPhase(
          id: 'phase_1',
          name: 'Phase One',
          briefing: 'Do the thing.',
          character: 'Handler',
          objective: 'Complete objective',
          educationalContent: ['Fact 1', 'Fact 2'],
        ),
      ],
      choicePoints: [
        ChoicePoint(
          id: 'choice_1',
          triggerAfterPhase: 'phase_1',
          prompt: 'What do you do?',
          options: [
            ChoiceOption(
              id: 'opt_a',
              label: 'Option A',
              description: 'Safe choice',
              consequences: ChoiceConsequence(
                reputationChanges: {'patriot': 2},
                handlerTrustDelta: 1,
                narrativeFlag: 'chose_safe',
              ),
            ),
            ChoiceOption(
              id: 'opt_b',
              label: 'Option B',
              description: 'Risky choice',
              consequences: ChoiceConsequence(
                reputationChanges: {'grey': 3},
                handlerTrustDelta: -1,
                unlocksMissions: ['follow_up_mission'],
                narrativeFlag: 'chose_risky',
              ),
            ),
          ],
        ),
      ],
      educationalFacts: ['General fact 1'],
    );
  }

  group('MissionData', () {
    test('creates with all fields', () {
      final mission = buildTestMission();
      expect(mission.id, 'test_mission');
      expect(mission.name, 'Test Mission');
      expect(mission.phases.length, 1);
      expect(mission.choicePoints.length, 1);
      expect(mission.choicePoints[0].options.length, 2);
    });

    test('choice consequences have correct values', () {
      final mission = buildTestMission();
      final opt = mission.choicePoints[0].options[1];
      expect(opt.consequences.reputationChanges['grey'], 3);
      expect(opt.consequences.handlerTrustDelta, -1);
      expect(opt.consequences.unlocksMissions, ['follow_up_mission']);
      expect(opt.consequences.narrativeFlag, 'chose_risky');
    });

    test('phase has educational content', () {
      final mission = buildTestMission();
      expect(mission.phases[0].educationalContent, ['Fact 1', 'Fact 2']);
    });
  });

  group('MissionAdapter', () {
    test('toLegacyMap produces map compatible with MissionScreen', () {
      final mission = buildTestMission();
      final legacy = MissionAdapter.toLegacyMap(mission);

      expect(legacy['id'], 'test_mission');
      expect(legacy['name'], 'Test Mission');
      expect(legacy['difficulty'], 'Medium');
      expect(legacy['description'], 'A test');
      expect(legacy['character'], 'Handler');
      expect(legacy['briefing'], 'Do the thing.');
      expect(legacy['facts'], isA<List<String>>());
      expect(legacy['reward'], 1000);
      expect(legacy['isMissionData'], true);
    });
  });
}
