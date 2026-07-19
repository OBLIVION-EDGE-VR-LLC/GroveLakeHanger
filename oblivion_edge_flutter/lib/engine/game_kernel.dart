import 'event_bus.dart';
import 'message_broker.dart';
import 'asset_registry.dart';
import 'concurrency_manager.dart';
import '../models/blackboard.dart';

/// N64-style core game loop. Everything is pre-allocated at init().
/// tick() runs one frame: drain events, snapshot blackboard, run workers,
/// merge results, route events to subscribers.
class GameKernel {
  late final EventBus eventBus;
  late final MessageBroker broker;
  late final Blackboard blackboard;
  late final AssetRegistry assets;
  late final ConcurrencyManager concurrency;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  /// Called once at startup. Pre-allocates all pools, spawns workers,
  /// loads flyweight assets.
  Future<void> init() async {
    eventBus = EventBus(channelCapacity: 64);
    broker = MessageBroker();
    blackboard = Blackboard();
    assets = AssetRegistry();
    concurrency = ConcurrencyManager(threadCount: 4, processCount: 2);
    await concurrency.init();
    _isRunning = true;
  }

  /// One frame. Called at fixed timestep.
  /// [dt] is delta time in seconds (e.g., 0.016 for 60fps).
  void tick(double dt) {
    if (!_isRunning) return;

    // Step 1: Write dt to blackboard for workers
    blackboard.section('world').write<double>('dt', dt);

    // Step 2: Route all events through broker to subscribers
    broker.route(eventBus);
  }

  /// Shutdown. Release all resources.
  Future<void> dispose() async {
    _isRunning = false;
    eventBus.clear();
    broker.clearSubscriptions();
    assets.clear();
    await concurrency.dispose();
  }
}
