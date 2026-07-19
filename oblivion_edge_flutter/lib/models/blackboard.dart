/// A single section of the blackboard. Stores key-value pairs
/// with a version counter that increments on every write.
/// Only the main thread should call write(). Workers read snapshots.
class BlackboardSection {
  final Map<String, dynamic> _data = {};
  int _version = 0;

  int get version => _version;

  T? read<T>(String key) {
    return _data[key] as T?;
  }

  void write<T>(String key, T value) {
    _data[key] = value;
    _version++;
  }

  Map<String, dynamic> snapshot() {
    return Map<String, dynamic>.from(_data);
  }
}

/// Shared blackboard — the single source of truth for all game state
/// during the frame loop. Sections partition data by domain.
///
/// Concurrency contract:
/// - Main thread: reads and writes freely
/// - Thread pool workers: read from snapshot only
/// - Process pool workers: receive frozen snapshot via IPC
class Blackboard {
  final Map<String, BlackboardSection> _sections = {};

  static const List<String> defaultSections = [
    'world',
    'mission',
    'signals',
    'narrative',
    'player',
  ];

  Blackboard() {
    for (final name in defaultSections) {
      _sections[name] = BlackboardSection();
    }
  }

  BlackboardSection section(String name) {
    return _sections.putIfAbsent(name, () => BlackboardSection());
  }

  Map<String, Map<String, dynamic>> snapshot() {
    return _sections.map((key, section) => MapEntry(key, section.snapshot()));
  }
}
