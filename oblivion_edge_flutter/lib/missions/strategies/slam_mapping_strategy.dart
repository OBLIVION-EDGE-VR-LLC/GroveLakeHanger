import '../../engine/event_bus.dart';
import 'mission_strategy.dart';

class SlamMappingStrategy extends MissionStrategy {
  final int totalWaypoints;
  int _waypointsReached = 0;
  bool _complete = false;

  SlamMappingStrategy({required this.totalWaypoints});

  @override
  bool get isComplete => _complete;

  @override
  void onEnter(MissionContext ctx) {
    _waypointsReached = 0;
    _complete = false;
    ctx.blackboard.section('mission').write<double>('slamCoverage', 0.0);
    ctx.blackboard.section('mission').write<int>('waypointsRemaining', totalWaypoints);
  }

  @override
  void onTick(MissionContext ctx, double dt) {
    final coverage = _waypointsReached / totalWaypoints;
    ctx.blackboard.section('mission').write<double>('slamCoverage', coverage);
    ctx.blackboard.section('mission').write<int>(
      'waypointsRemaining',
      totalWaypoints - _waypointsReached,
    );

    if (coverage >= 1.0) {
      _complete = true;
      ctx.eventBus.publish(MissionEvent(
        type: 'slam_complete',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  @override
  void onEvent(GameEvent event) {
    if (event is MissionEvent && event.type == 'waypoint_reached') {
      _waypointsReached++;
    }
  }

  @override
  void onExit(MissionContext ctx) {}
}
