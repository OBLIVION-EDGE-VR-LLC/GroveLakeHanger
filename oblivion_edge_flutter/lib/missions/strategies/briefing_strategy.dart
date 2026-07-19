import '../../engine/event_bus.dart';
import '../../models/mission_data.dart';
import 'mission_strategy.dart';

class BriefingStrategy extends MissionStrategy {
  final MissionPhase phase;
  bool _complete = false;

  BriefingStrategy({required this.phase});

  @override
  bool get isComplete => _complete;

  @override
  void onEnter(MissionContext ctx) {
    ctx.eventBus.publish(NarrativeEvent(
      type: 'briefing',
      character: phase.character,
      text: phase.briefing,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    ctx.blackboard.section('mission').write<String>('currentPhase', phase.id);
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
