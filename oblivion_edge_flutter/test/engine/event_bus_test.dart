import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/event_bus.dart';

void main() {
  group('EventBus', () {
    test('publish and drain typed events', () {
      final bus = EventBus(channelCapacity: 16);
      bus.publish(MissionEvent(type: 'slam_complete', timestamp: 1));
      bus.publish(MissionEvent(type: 'phase_change', timestamp: 2));
      bus.publish(NarrativeEvent(
        type: 'dialogue',
        character: 'Handler',
        text: 'Begin SLAM pass.',
        timestamp: 3,
      ));

      final missionEvents = bus.drain<MissionEvent>();
      expect(missionEvents.length, 2);
      expect(missionEvents[0].type, 'slam_complete');
      expect(missionEvents[1].type, 'phase_change');

      final narrativeEvents = bus.drain<NarrativeEvent>();
      expect(narrativeEvents.length, 1);
      expect(narrativeEvents[0].character, 'Handler');
    });

    test('drain returns empty list when no events', () {
      final bus = EventBus(channelCapacity: 8);
      expect(bus.drain<InputEvent>(), isEmpty);
    });

    test('clear removes all events from all channels', () {
      final bus = EventBus(channelCapacity: 8);
      bus.publish(MissionEvent(type: 'test', timestamp: 1));
      bus.publish(InputEvent(action: 'tap', timestamp: 2));
      bus.clear();
      expect(bus.drain<MissionEvent>(), isEmpty);
      expect(bus.drain<InputEvent>(), isEmpty);
    });

    test('backpressure drops oldest when channel full', () {
      final bus = EventBus(channelCapacity: 2);
      bus.publish(MissionEvent(type: 'a', timestamp: 1));
      bus.publish(MissionEvent(type: 'b', timestamp: 2));
      bus.publish(MissionEvent(type: 'c', timestamp: 3));
      final events = bus.drain<MissionEvent>();
      expect(events.length, 2);
      expect(events[0].type, 'b');
      expect(events[1].type, 'c');
    });
  });
}
