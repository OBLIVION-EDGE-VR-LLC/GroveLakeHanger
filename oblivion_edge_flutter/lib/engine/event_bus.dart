import 'ring_buffer.dart';

/// Base class for all game events.
abstract class GameEvent {
  final int timestamp;
  GameEvent({required this.timestamp});
}

class InputEvent extends GameEvent {
  final String action;
  final double x;
  final double y;
  InputEvent({required this.action, this.x = 0, this.y = 0, required int timestamp})
      : super(timestamp: timestamp);
}

class TelemetryEvent extends GameEvent {
  final double altitude;
  final double speed;
  final double heading;
  TelemetryEvent({
    this.altitude = 0,
    this.speed = 0,
    this.heading = 0,
    required int timestamp,
  }) : super(timestamp: timestamp);
}

class MissionEvent extends GameEvent {
  final String type;
  final Map<String, dynamic> data;
  MissionEvent({required this.type, this.data = const {}, required int timestamp})
      : super(timestamp: timestamp);
}

class NarrativeEvent extends GameEvent {
  final String type;
  final String character;
  final String text;
  final List<String>? choices;
  NarrativeEvent({
    required this.type,
    this.character = '',
    this.text = '',
    this.choices,
    required int timestamp,
  }) : super(timestamp: timestamp);
}

class SystemEvent extends GameEvent {
  final String type;
  final String message;
  SystemEvent({required this.type, this.message = '', required int timestamp})
      : super(timestamp: timestamp);
}

/// Typed event bus using per-type ring buffer channels.
/// Backpressure drops oldest events when a channel overflows.
class EventBus {
  final int channelCapacity;
  final Map<Type, RingBuffer<GameEvent>> _channels = {};

  EventBus({this.channelCapacity = 64});

  RingBuffer<GameEvent> _getChannel<T extends GameEvent>() {
    return _channels.putIfAbsent(T, () => RingBuffer<GameEvent>(capacity: channelCapacity));
  }

  void publish<T extends GameEvent>(T event) {
    _getChannel<T>().write(event);
  }

  List<T> drain<T extends GameEvent>() {
    final channel = _channels[T];
    if (channel == null) return <T>[];
    final raw = channel.drainAll();
    return raw.cast<T>();
  }

  void clear() {
    for (final channel in _channels.values) {
      channel.drainAll();
    }
  }
}
