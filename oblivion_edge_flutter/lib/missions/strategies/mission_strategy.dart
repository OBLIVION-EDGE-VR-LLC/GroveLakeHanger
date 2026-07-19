import '../../engine/event_bus.dart';
import '../../models/blackboard.dart';

/// Context passed to strategies — provides access to shared state and events.
class MissionContext {
  final Blackboard blackboard;
  final EventBus eventBus;

  MissionContext({required this.blackboard, required this.eventBus});
}

/// Strategy interface. Each mission phase is a strategy implementation.
/// Strategies are pre-allocated and swapped by the MissionRunner.
abstract class MissionStrategy {
  bool get isComplete;

  void onEnter(MissionContext ctx);
  void onTick(MissionContext ctx, double dt);
  void onEvent(GameEvent event);
  void onExit(MissionContext ctx);
}
