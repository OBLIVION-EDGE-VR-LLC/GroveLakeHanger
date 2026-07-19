import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/models/game_state.dart';
import 'package:oblivion_edge_flight/models/mission_data.dart';
import 'package:oblivion_edge_flight/services/consequence_tracker.dart';

void main() {
  group('ConsequenceTracker', () {
    late GameStateModel state;
    late ConsequenceTracker tracker;

    setUp(() {
      state = GameStateModel();
      tracker = ConsequenceTracker();
    });

    test('applyConsequence updates reputation scores', () {
      final consequence = ChoiceConsequence(
        reputationChanges: {'patriot': 2, 'grey': -1},
        handlerTrustDelta: 1,
        narrativeFlag: 'test_flag',
      );
      tracker.applyConsequence(consequence, state);

      expect(state.reputationScores['patriot'], 2);
      expect(state.reputationScores['grey'], -1);
      expect(state.handlerTrust, 6);
      expect(state.narrativeFlags.contains('test_flag'), true);
    });

    test('applyConsequence accumulates across multiple calls', () {
      tracker.applyConsequence(
        ChoiceConsequence(reputationChanges: {'patriot': 2}, handlerTrustDelta: 1),
        state,
      );
      tracker.applyConsequence(
        ChoiceConsequence(reputationChanges: {'patriot': 3}, handlerTrustDelta: -2),
        state,
      );

      expect(state.reputationScores['patriot'], 5);
      expect(state.handlerTrust, 4);
    });

    test('isMissionAvailable checks skill requirements', () {
      final mission = MissionData(
        id: 'locked',
        name: 'Locked',
        description: 'Need skills',
        difficulty: 'hard',
        reward: 1000,
        skillRequirements: {'pilot': 5},
        phases: [],
      );

      expect(tracker.isMissionAvailable(mission, state), false);

      state.setSkillLevel('pilot', 5);
      expect(tracker.isMissionAvailable(mission, state), true);
    });

    test('isMissionAvailable checks locked missions', () {
      final mission = MissionData(
        id: 'target_mission',
        name: 'Target',
        description: 'Test',
        difficulty: 'easy',
        reward: 100,
        phases: [],
      );

      state.lockMission('target_mission');
      expect(tracker.isMissionAvailable(mission, state), false);

      state.unlockMission('target_mission');
      expect(tracker.isMissionAvailable(mission, state), true);
    });
  });
}
