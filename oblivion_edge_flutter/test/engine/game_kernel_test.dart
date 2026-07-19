import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/game_kernel.dart';
import 'package:oblivion_edge_flight/engine/event_bus.dart';

void main() {
  group('GameKernel', () {
    test('init sets up all subsystems', () async {
      final kernel = GameKernel();
      await kernel.init();

      expect(kernel.isRunning, true);
      expect(kernel.eventBus, isNotNull);
      expect(kernel.broker, isNotNull);
      expect(kernel.blackboard, isNotNull);
      expect(kernel.assets, isNotNull);
      expect(kernel.concurrency, isNotNull);

      await kernel.dispose();
    });

    test('tick processes one frame', () async {
      final kernel = GameKernel();
      await kernel.init();

      kernel.eventBus.publish(
        MissionEvent(type: 'test_event', timestamp: 1),
      );

      final received = <MissionEvent>[];
      kernel.broker.subscribe<MissionEvent>((e) => received.add(e));

      kernel.tick(0.016);

      expect(received.length, 1);
      expect(received[0].type, 'test_event');

      await kernel.dispose();
    });

    test('dispose cleans up all subsystems', () async {
      final kernel = GameKernel();
      await kernel.init();
      await kernel.dispose();

      expect(kernel.isRunning, false);
    });
  });
}
