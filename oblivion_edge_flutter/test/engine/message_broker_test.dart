import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/event_bus.dart';
import 'package:oblivion_edge_flight/engine/message_broker.dart';

void main() {
  group('MessageBroker', () {
    test('routes events to subscribers by type', () {
      final bus = EventBus(channelCapacity: 16);
      final broker = MessageBroker();
      final receivedMission = <MissionEvent>[];
      final receivedNarrative = <NarrativeEvent>[];

      broker.subscribe<MissionEvent>((e) => receivedMission.add(e));
      broker.subscribe<NarrativeEvent>((e) => receivedNarrative.add(e));

      bus.publish(MissionEvent(type: 'slam_complete', timestamp: 1));
      bus.publish(NarrativeEvent(type: 'dialogue', text: 'Hello', timestamp: 2));
      bus.publish(MissionEvent(type: 'phase_change', timestamp: 3));

      broker.route(bus);

      expect(receivedMission.length, 2);
      expect(receivedNarrative.length, 1);
      expect(receivedMission[0].type, 'slam_complete');
      expect(receivedNarrative[0].text, 'Hello');
    });

    test('multiple subscribers for same type all receive events', () {
      final bus = EventBus(channelCapacity: 8);
      final broker = MessageBroker();
      int count1 = 0;
      int count2 = 0;

      broker.subscribe<MissionEvent>((_) => count1++);
      broker.subscribe<MissionEvent>((_) => count2++);

      bus.publish(MissionEvent(type: 'test', timestamp: 1));
      broker.route(bus);

      expect(count1, 1);
      expect(count2, 1);
    });

    test('no subscribers means events are drained but not delivered', () {
      final bus = EventBus(channelCapacity: 8);
      final broker = MessageBroker();

      bus.publish(MissionEvent(type: 'orphan', timestamp: 1));
      broker.route(bus);

      expect(bus.drain<MissionEvent>(), isEmpty);
    });

    test('clearSubscriptions removes all handlers', () {
      final bus = EventBus(channelCapacity: 8);
      final broker = MessageBroker();
      int count = 0;

      broker.subscribe<MissionEvent>((_) => count++);
      broker.clearSubscriptions();

      bus.publish(MissionEvent(type: 'test', timestamp: 1));
      broker.route(bus);

      expect(count, 0);
    });
  });
}
