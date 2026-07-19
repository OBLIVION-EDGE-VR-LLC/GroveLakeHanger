import '../../engine/event_bus.dart';
import '../../models/mission_data.dart';
import 'mission_strategy.dart';

class ChoiceStrategy extends MissionStrategy {
  final ChoicePoint choicePoint;
  bool _complete = false;
  ChoiceOption? selectedOption;

  ChoiceStrategy({required this.choicePoint});

  @override
  bool get isComplete => _complete;

  @override
  void onEnter(MissionContext ctx) {
    _complete = false;
    selectedOption = null;
    ctx.blackboard.section('mission').write<String>(
      'pendingChoicePoint',
      choicePoint.id,
    );
    ctx.eventBus.publish(NarrativeEvent(
      type: 'choice',
      text: choicePoint.prompt,
      choices: choicePoint.options.map((o) => o.id).toList(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  @override
  void onTick(MissionContext ctx, double dt) {}

  @override
  void onEvent(GameEvent event) {
    if (event is InputEvent && event.action.startsWith('choose:')) {
      final choiceId = event.action.substring('choose:'.length);
      final option = choicePoint.options
          .where((o) => o.id == choiceId)
          .firstOrNull;
      if (option != null) {
        selectedOption = option;
        _complete = true;
      }
    }
  }

  @override
  void onExit(MissionContext ctx) {
    if (selectedOption != null) {
      final c = selectedOption!.consequences;
      ctx.blackboard.section('narrative').write<String>(
        'lastNarrativeFlag',
        c.narrativeFlag,
      );
      ctx.blackboard.section('narrative').write<Map<String, int>>(
        'lastReputationChanges',
        c.reputationChanges,
      );
      ctx.blackboard.section('narrative').write<int>(
        'lastHandlerTrustDelta',
        c.handlerTrustDelta,
      );
      ctx.blackboard.section('mission').write<String?>(
        'pendingChoicePoint',
        null,
      );
    }
  }
}
