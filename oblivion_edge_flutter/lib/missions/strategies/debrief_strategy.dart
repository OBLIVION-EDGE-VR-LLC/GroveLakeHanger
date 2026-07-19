import '../../engine/event_bus.dart';
import 'mission_strategy.dart';

class DebriefStrategy extends MissionStrategy {
  final String missionName;
  final int reward;
  final List<String> facts;
  bool _complete = false;

  DebriefStrategy({
    required this.missionName,
    required this.reward,
    required this.facts,
  });

  @override
  bool get isComplete => _complete;

  @override
  void onEnter(MissionContext ctx) {
    _complete = false;
    ctx.eventBus.publish(NarrativeEvent(
      type: 'debrief',
      text: 'Mission "$missionName" complete. Reward: $reward PTS',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  @override
  void onTick(MissionContext ctx, double dt) {}

  @override
  void onEvent(GameEvent event) {
    if (event is InputEvent && event.action == 'advance') {
      _complete = true;
    }
  }

  @override
  void onExit(MissionContext ctx) {}
}
