import '../engine/event_bus.dart';
import '../models/mission_data.dart';
import 'strategies/mission_strategy.dart';
import 'strategies/briefing_strategy.dart';
import 'strategies/slam_mapping_strategy.dart';
import 'strategies/sigint_strategy.dart';
import 'strategies/choice_strategy.dart';
import 'strategies/debrief_strategy.dart';

class PlayerCommand {
  final String type;
  final Map<String, dynamic> data;
  final int timestamp;

  PlayerCommand({required this.type, this.data = const {}, required this.timestamp});
}

/// Runs a mission by walking through a pre-built queue of strategies.
/// Swapping strategies is a pointer change — no allocation.
class MissionRunner {
  final List<MissionStrategy> _strategyQueue = [];
  int _currentIndex = -1;
  final List<PlayerCommand> _commandHistory = [];

  MissionStrategy? get currentStrategy =>
      _currentIndex >= 0 && _currentIndex < _strategyQueue.length
          ? _strategyQueue[_currentIndex]
          : null;

  bool get isComplete =>
      _currentIndex >= _strategyQueue.length && _strategyQueue.isNotEmpty;

  List<PlayerCommand> get commandHistory => List.unmodifiable(_commandHistory);

  /// Build the strategy queue from MissionData and enter the first strategy.
  void loadMission(MissionData mission, MissionContext ctx) {
    _strategyQueue.clear();
    _commandHistory.clear();
    _currentIndex = 0;

    for (final phase in mission.phases) {
      // Briefing for this phase
      _strategyQueue.add(BriefingStrategy(phase: phase));

      // Phase-specific gameplay strategy
      if (phase.id.contains('slam')) {
        _strategyQueue.add(SlamMappingStrategy(totalWaypoints: 5));
      } else if (phase.id.contains('sigint')) {
        _strategyQueue.add(SigintStrategy(targetSignalCount: 3));
      }

      // Check if there's a choice point after this phase
      final choicePoint = mission.choicePoints
          .where((cp) => cp.triggerAfterPhase == phase.id)
          .firstOrNull;

      // Choice after phase if defined
      if (choicePoint != null) {
        _strategyQueue.add(ChoiceStrategy(choicePoint: choicePoint));
      }
    }

    // Debrief at the end
    _strategyQueue.add(DebriefStrategy(
      missionName: mission.name,
      reward: mission.reward,
      facts: mission.educationalFacts,
    ));

    // Enter the first strategy
    if (_strategyQueue.isNotEmpty) {
      _strategyQueue[_currentIndex].onEnter(ctx);
    }
  }

  void tick(MissionContext ctx, double dt) {
    if (isComplete || currentStrategy == null) return;

    currentStrategy!.onTick(ctx, dt);

    if (currentStrategy!.isComplete) {
      _advance(ctx);
    }
  }

  void handleEvent(GameEvent event) {
    if (currentStrategy == null) return;

    // Record as command
    if (event is InputEvent) {
      _commandHistory.add(PlayerCommand(
        type: event.action,
        timestamp: event.timestamp,
      ));
    }

    currentStrategy!.onEvent(event);
  }

  void _advance(MissionContext ctx) {
    if (currentStrategy != null) {
      currentStrategy!.onExit(ctx);
    }
    _currentIndex++;
    if (!isComplete && currentStrategy != null) {
      currentStrategy!.onEnter(ctx);
    }
  }
}
