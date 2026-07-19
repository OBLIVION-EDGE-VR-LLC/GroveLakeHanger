import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../engine/event_bus.dart';
import '../models/blackboard.dart';
import '../models/game_state.dart';
import '../models/mission_data.dart';
import '../missions/mission_runner.dart';
import '../missions/strategies/mission_strategy.dart';
import '../missions/strategies/briefing_strategy.dart';
import '../missions/strategies/choice_strategy.dart';
import '../missions/strategies/debrief_strategy.dart';
import '../missions/strategies/slam_mapping_strategy.dart';
import '../missions/strategies/sigint_strategy.dart';
import '../services/consequence_tracker.dart';
import '../theme/oblivion_theme.dart';
import '../widgets/choice_panel.dart';
import '../widgets/slam_hud.dart';
import '../widgets/sigint_hud.dart';

class MissionDetailScreen extends StatefulWidget {
  final MissionData mission;

  const MissionDetailScreen({Key? key, required this.mission}) : super(key: key);

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen>
    with SingleTickerProviderStateMixin {
  late final MissionRunner _runner;
  late final MissionContext _ctx;
  late final ConsequenceTracker _consequenceTracker;
  late final Ticker _ticker;

  // UI state derived from blackboard
  String _briefingText = '';
  String _briefingCharacter = '';
  double _slamCoverage = 0.0;
  int _waypointsRemaining = 0;
  double _signalStrength = 0.0;
  int _interceptedCount = 0;
  ChoicePoint? _activeChoice;
  bool _missionComplete = false;

  @override
  void initState() {
    super.initState();
    _runner = MissionRunner();
    _ctx = MissionContext(
      blackboard: Blackboard(),
      eventBus: EventBus(channelCapacity: 64),
    );
    _consequenceTracker = ConsequenceTracker();

    _runner.loadMission(widget.mission, _ctx);

    _ticker = createTicker(_onTick);
    _ticker.start();

    // Process initial events
    _processEvents();
  }

  void _onTick(Duration elapsed) {
    _runner.tick(_ctx, 0.016);
    _processEvents();
    _updateFromBlackboard();

    if (_runner.isComplete && !_missionComplete) {
      setState(() => _missionComplete = true);
      _onMissionComplete();
    }
  }

  void _processEvents() {
    final narrativeEvents = _ctx.eventBus.drain<NarrativeEvent>();
    for (final event in narrativeEvents) {
      setState(() {
        if (event.type == 'briefing' || event.type == 'debrief') {
          _briefingText = event.text;
          _briefingCharacter = event.character;
        }
        if (event.type == 'choice' && event.choices != null) {
          _activeChoice = widget.mission.choicePoints
              .where(
                  (cp) => cp.options.any((o) => event.choices!.contains(o.id)))
              .firstOrNull;
        }
      });
    }

    // Drain other events so they don't pile up
    _ctx.eventBus.drain<MissionEvent>();
    _ctx.eventBus.drain<InputEvent>();
  }

  void _updateFromBlackboard() {
    final mission = _ctx.blackboard.section('mission');
    final signals = _ctx.blackboard.section('signals');

    setState(() {
      _slamCoverage = mission.read<double>('slamCoverage') ?? 0.0;
      _waypointsRemaining = mission.read<int>('waypointsRemaining') ?? 0;
      _signalStrength = signals.read<double>('signalStrength') ?? 0.0;
      _interceptedCount = signals.read<int>('interceptedCount') ?? 0;
    });
  }

  void _onMissionComplete() {
    context.read<GameStateModel>().completeMission(widget.mission.id);
  }

  void _handleAdvance() {
    _runner.handleEvent(InputEvent(
      action: 'advance',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _handleChoice(String choiceId) {
    setState(() => _activeChoice = null);

    // Apply consequences immediately
    final choicePoint = widget.mission.choicePoints
        .where((cp) => cp.options.any((o) => o.id == choiceId))
        .firstOrNull;
    if (choicePoint != null) {
      final option = choicePoint.options.firstWhere((o) => o.id == choiceId);
      final gameState = context.read<GameStateModel>();
      _consequenceTracker.applyConsequence(option.consequences, gameState);
    }

    _runner.handleEvent(InputEvent(
      action: 'choose:$choiceId',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _handleWaypointReached() {
    _runner.handleEvent(MissionEvent(
      type: 'waypoint_reached',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _handleSignalIntercepted() {
    _runner.handleEvent(MissionEvent(
      type: 'signal_intercepted',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OblivionTheme.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMainContent(),

            if (_runner.currentStrategy is SlamMappingStrategy)
              Positioned(
                top: 16,
                left: 16,
                child: SlamHud(
                  coverage: _slamCoverage,
                  waypointsRemaining: _waypointsRemaining,
                ),
              ),

            if (_runner.currentStrategy is SigintStrategy)
              Positioned(
                top: 16,
                left: 16,
                child: SigintHud(
                  signalStrength: _signalStrength,
                  interceptedCount: _interceptedCount,
                  targetCount: 3,
                ),
              ),

            if (_activeChoice != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ChoicePanel(
                    choicePoint: _activeChoice!,
                    onChoiceSelected: _handleChoice,
                  ),
                ),
              ),

            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: OblivionTheme.lightGray),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final strategy = _runner.currentStrategy;

    if (strategy is BriefingStrategy || strategy is DebriefStrategy) {
      return _buildBriefingView();
    }

    if (strategy is SlamMappingStrategy) {
      return _buildGameplayView('SLAM MAPPING ACTIVE', _handleWaypointReached);
    }

    if (strategy is SigintStrategy) {
      return _buildGameplayView(
          'SIGINT COLLECTION ACTIVE', _handleSignalIntercepted);
    }

    if (_missionComplete) {
      return _buildMissionCompleteView();
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBriefingView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mission.name.toUpperCase(),
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          if (_briefingCharacter.isNotEmpty)
            Text(
              _briefingCharacter.toUpperCase(),
              style: const TextStyle(
                color: OblivionTheme.secondaryGold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: OblivionTheme.primaryCyan),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black45,
            ),
            child: Text(
              _briefingText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: _handleAdvance,
              style: ElevatedButton.styleFrom(
                backgroundColor: OblivionTheme.primaryCyan,
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: Text(
                _runner.currentStrategy is DebriefStrategy
                    ? 'COMPLETE MISSION'
                    : 'PROCEED',
                style: const TextStyle(
                  color: OblivionTheme.darkBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGameplayView(String label, VoidCallback onAction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: OblivionTheme.primaryCyan,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: OblivionTheme.secondaryGold,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              label.contains('SLAM') ? 'WAYPOINT REACHED' : 'INTERCEPT SIGNAL',
              style: const TextStyle(
                color: OblivionTheme.darkBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCompleteView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'MISSION COMPLETE',
            style: TextStyle(
              color: OblivionTheme.secondaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '+${widget.mission.reward} PTS',
            style: const TextStyle(
              color: OblivionTheme.neonGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('RETURN TO BASE'),
          ),
        ],
      ),
    );
  }
}
