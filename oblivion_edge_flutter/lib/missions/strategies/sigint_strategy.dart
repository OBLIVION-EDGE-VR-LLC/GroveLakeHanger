import '../../engine/event_bus.dart';
import 'mission_strategy.dart';

class SigintStrategy extends MissionStrategy {
  final int targetSignalCount;
  int _interceptedCount = 0;
  bool _complete = false;

  SigintStrategy({required this.targetSignalCount});

  @override
  bool get isComplete => _complete;

  @override
  void onEnter(MissionContext ctx) {
    _interceptedCount = 0;
    _complete = false;
    ctx.blackboard.section('signals').write<int>('interceptedCount', 0);
    ctx.blackboard.section('signals').write<double>('signalStrength', 0.0);
  }

  @override
  void onTick(MissionContext ctx, double dt) {
    ctx.blackboard.section('signals').write<int>('interceptedCount', _interceptedCount);

    if (_interceptedCount >= targetSignalCount) {
      _complete = true;
      ctx.eventBus.publish(MissionEvent(
        type: 'sigint_complete',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  @override
  void onEvent(GameEvent event) {
    if (event is MissionEvent && event.type == 'signal_intercepted') {
      _interceptedCount++;
    }
  }

  @override
  void onExit(MissionContext ctx) {}
}
