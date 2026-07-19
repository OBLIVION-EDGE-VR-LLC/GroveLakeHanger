import 'event_bus.dart';

typedef EventHandler<T extends GameEvent> = void Function(T event);

class _Subscription {
  final Type eventType;
  final void Function(GameEvent) handler;
  _Subscription(this.eventType, this.handler);
}

/// Routes events from the EventBus to typed subscribers.
/// Called once per tick — deterministic, single-pass delivery.
class MessageBroker {
  final List<_Subscription> _subscriptions = [];

  /// All event types that have been subscribed to.
  final Set<Type> _subscribedTypes = {};

  void subscribe<T extends GameEvent>(EventHandler<T> handler) {
    _subscribedTypes.add(T);
    _subscriptions.add(_Subscription(T, (e) => handler(e as T)));
  }

  /// Drain all subscribed channels from [bus] and deliver to handlers.
  void route(EventBus bus) {
    for (final type in _subscribedTypes) {
      final events = _drainByType(bus, type);
      if (events.isEmpty) continue;
      for (final sub in _subscriptions) {
        if (sub.eventType == type) {
          for (final event in events) {
            sub.handler(event);
          }
        }
      }
    }
  }

  List<GameEvent> _drainByType(EventBus bus, Type type) {
    if (type == MissionEvent) return bus.drain<MissionEvent>();
    if (type == NarrativeEvent) return bus.drain<NarrativeEvent>();
    if (type == InputEvent) return bus.drain<InputEvent>();
    if (type == TelemetryEvent) return bus.drain<TelemetryEvent>();
    if (type == SystemEvent) return bus.drain<SystemEvent>();
    return [];
  }

  void clearSubscriptions() {
    _subscriptions.clear();
    _subscribedTypes.clear();
  }
}
