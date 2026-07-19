import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/event_bus.dart';
import 'package:oblivion_edge_flight/models/blackboard.dart';
import 'package:oblivion_edge_flight/models/mission_data.dart';
import 'package:oblivion_edge_flight/missions/strategies/mission_strategy.dart';
import 'package:oblivion_edge_flight/missions/strategies/briefing_strategy.dart';
import 'package:oblivion_edge_flight/missions/strategies/slam_mapping_strategy.dart';
import 'package:oblivion_edge_flight/missions/strategies/sigint_strategy.dart';
import 'package:oblivion_edge_flight/missions/strategies/choice_strategy.dart';
import 'package:oblivion_edge_flight/missions/strategies/debrief_strategy.dart';

void main() {
  late MissionContext ctx;

  setUp(() {
    ctx = MissionContext(
      blackboard: Blackboard(),
      eventBus: EventBus(channelCapacity: 16),
    );
  });

  group('BriefingStrategy', () {
    test('onEnter publishes NarrativeEvent with briefing', () {
      final phase = MissionPhase(
        id: 'slam_pass',
        name: 'SLAM Mapping Pass',
        briefing: 'Map the facility.',
        character: 'Handler',
        objective: 'Run SLAM pass',
        educationalContent: ['SLAM builds 3D maps'],
      );
      final strategy = BriefingStrategy(phase: phase);
      strategy.onEnter(ctx);

      final events = ctx.eventBus.drain<NarrativeEvent>();
      expect(events.length, 1);
      expect(events[0].character, 'Handler');
      expect(events[0].text, 'Map the facility.');
    });

    test('completes when advance event received', () {
      final phase = MissionPhase(
        id: 'test',
        name: 'Test',
        briefing: 'Brief',
        character: 'C',
        objective: 'Obj',
      );
      final strategy = BriefingStrategy(phase: phase);
      strategy.onEnter(ctx);

      expect(strategy.isComplete, false);
      strategy.onEvent(InputEvent(action: 'advance', timestamp: 1));
      expect(strategy.isComplete, true);
    });
  });

  group('SlamMappingStrategy', () {
    test('onEnter sets slamCoverage to 0', () {
      final strategy = SlamMappingStrategy(totalWaypoints: 5);
      strategy.onEnter(ctx);

      expect(
        ctx.blackboard.section('mission').read<double>('slamCoverage'),
        0.0,
      );
    });

    test('onTick increments coverage and publishes mission events', () {
      final strategy = SlamMappingStrategy(totalWaypoints: 5);
      strategy.onEnter(ctx);

      strategy.onEvent(MissionEvent(type: 'waypoint_reached', timestamp: 1));
      strategy.onTick(ctx, 0.016);

      final coverage = ctx.blackboard.section('mission').read<double>('slamCoverage');
      expect(coverage, closeTo(0.2, 0.01));
    });

    test('completes when coverage reaches 1.0', () {
      final strategy = SlamMappingStrategy(totalWaypoints: 2);
      strategy.onEnter(ctx);

      strategy.onEvent(MissionEvent(type: 'waypoint_reached', timestamp: 1));
      strategy.onTick(ctx, 0.016);
      strategy.onEvent(MissionEvent(type: 'waypoint_reached', timestamp: 2));
      strategy.onTick(ctx, 0.016);

      expect(strategy.isComplete, true);
    });
  });

  group('SigintStrategy', () {
    test('onEnter initializes signal tracking on blackboard', () {
      final strategy = SigintStrategy(targetSignalCount: 3);
      strategy.onEnter(ctx);

      expect(
        ctx.blackboard.section('signals').read<int>('interceptedCount'),
        0,
      );
    });

    test('completes when target signals intercepted', () {
      final strategy = SigintStrategy(targetSignalCount: 2);
      strategy.onEnter(ctx);

      strategy.onEvent(MissionEvent(type: 'signal_intercepted', timestamp: 1));
      strategy.onTick(ctx, 0.016);
      strategy.onEvent(MissionEvent(type: 'signal_intercepted', timestamp: 2));
      strategy.onTick(ctx, 0.016);

      expect(strategy.isComplete, true);
    });
  });

  group('ChoiceStrategy', () {
    test('onEnter publishes choice prompt as NarrativeEvent', () {
      final choicePoint = ChoicePoint(
        id: 'what_did_you_see',
        triggerAfterPhase: 'slam_pass',
        prompt: 'How do you proceed?',
        options: [
          ChoiceOption(
            id: 'military_only',
            label: 'Military frequencies only',
            description: 'Safe',
            consequences: ChoiceConsequence(
              reputationChanges: {'patriot': 2},
              handlerTrustDelta: 1,
              narrativeFlag: 'military_only',
            ),
          ),
        ],
      );
      final strategy = ChoiceStrategy(choicePoint: choicePoint);
      strategy.onEnter(ctx);

      final events = ctx.eventBus.drain<NarrativeEvent>();
      expect(events.length, 1);
      expect(events[0].text, 'How do you proceed?');
      expect(events[0].choices, isNotNull);
      expect(events[0].choices!.length, 1);
    });

    test('completes when choice is made and writes consequences', () {
      final choicePoint = ChoicePoint(
        id: 'test_choice',
        triggerAfterPhase: 'phase_1',
        prompt: 'Choose',
        options: [
          ChoiceOption(
            id: 'opt_a',
            label: 'A',
            description: 'A desc',
            consequences: ChoiceConsequence(
              reputationChanges: {'patriot': 2},
              handlerTrustDelta: 1,
              narrativeFlag: 'chose_a',
            ),
          ),
        ],
      );
      final strategy = ChoiceStrategy(choicePoint: choicePoint);
      strategy.onEnter(ctx);

      expect(strategy.isComplete, false);
      strategy.onEvent(InputEvent(action: 'choose:opt_a', timestamp: 1));
      expect(strategy.isComplete, true);

      strategy.onExit(ctx);
      expect(
        ctx.blackboard.section('narrative').read<String>('lastNarrativeFlag'),
        'chose_a',
      );
    });
  });

  group('DebriefStrategy', () {
    test('onEnter publishes debrief narrative', () {
      final strategy = DebriefStrategy(
        missionName: 'Silent Wings',
        reward: 1200,
        facts: ['SLAM builds 3D maps', 'BWB has low RCS'],
      );
      strategy.onEnter(ctx);

      final events = ctx.eventBus.drain<NarrativeEvent>();
      expect(events.length, 1);
      expect(events[0].type, 'debrief');
    });

    test('completes when acknowledged', () {
      final strategy = DebriefStrategy(
        missionName: 'Test',
        reward: 500,
        facts: [],
      );
      strategy.onEnter(ctx);

      expect(strategy.isComplete, false);
      strategy.onEvent(InputEvent(action: 'advance', timestamp: 1));
      expect(strategy.isComplete, true);
    });
  });
}
