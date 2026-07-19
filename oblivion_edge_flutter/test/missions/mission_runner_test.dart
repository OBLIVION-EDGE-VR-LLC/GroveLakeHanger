import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/event_bus.dart';
import 'package:oblivion_edge_flight/models/blackboard.dart';
import 'package:oblivion_edge_flight/models/mission_data.dart';
import 'package:oblivion_edge_flight/missions/mission_runner.dart';
import 'package:oblivion_edge_flight/missions/strategies/mission_strategy.dart';
import 'package:oblivion_edge_flight/missions/strategies/briefing_strategy.dart';

void main() {
  late MissionContext ctx;

  setUp(() {
    ctx = MissionContext(
      blackboard: Blackboard(),
      eventBus: EventBus(channelCapacity: 16),
    );
  });

  MissionData twoPhase() {
    return MissionData(
      id: 'test_two_phase',
      name: 'Two Phase Test',
      description: 'Test mission',
      difficulty: 'easy',
      reward: 500,
      phases: [
        MissionPhase(
          id: 'phase_1',
          name: 'Phase 1',
          briefing: 'First briefing',
          character: 'Handler',
          objective: 'Do first thing',
        ),
        MissionPhase(
          id: 'phase_2',
          name: 'Phase 2',
          briefing: 'Second briefing',
          character: 'Handler',
          objective: 'Do second thing',
        ),
      ],
      educationalFacts: ['Fact one'],
    );
  }

  group('MissionRunner', () {
    test('loadMission sets up strategy queue and enters first strategy', () {
      final runner = MissionRunner();
      runner.loadMission(twoPhase(), ctx);

      expect(runner.isComplete, false);
      expect(runner.currentStrategy, isA<BriefingStrategy>());
    });

    test('advances to next strategy when current completes', () {
      final runner = MissionRunner();
      runner.loadMission(twoPhase(), ctx);

      // Drain initial briefing event
      ctx.eventBus.drain<NarrativeEvent>();

      // Complete first briefing
      runner.handleEvent(InputEvent(action: 'advance', timestamp: 1));
      runner.tick(ctx, 0.016);

      // Should have advanced to second briefing
      final events = ctx.eventBus.drain<NarrativeEvent>();
      expect(events.length, 1);
      expect(events[0].text, 'Second briefing');
    });

    test('isComplete when all strategies finished', () {
      final runner = MissionRunner();
      final mission = MissionData(
        id: 'simple',
        name: 'Simple',
        description: 'One phase',
        difficulty: 'easy',
        reward: 100,
        phases: [
          MissionPhase(
            id: 'only',
            name: 'Only',
            briefing: 'Done',
            character: 'C',
            objective: 'O',
          ),
        ],
        educationalFacts: [],
      );
      runner.loadMission(mission, ctx);

      // Complete briefing
      runner.handleEvent(InputEvent(action: 'advance', timestamp: 1));
      runner.tick(ctx, 0.016);

      // Complete debrief
      runner.handleEvent(InputEvent(action: 'advance', timestamp: 2));
      runner.tick(ctx, 0.016);

      expect(runner.isComplete, true);
    });

    test('records commands in history', () {
      final runner = MissionRunner();
      runner.loadMission(twoPhase(), ctx);

      runner.handleEvent(InputEvent(action: 'advance', timestamp: 1));
      runner.tick(ctx, 0.016);

      expect(runner.commandHistory.length, 1);
      expect(runner.commandHistory[0].type, 'advance');
    });
  });
}
