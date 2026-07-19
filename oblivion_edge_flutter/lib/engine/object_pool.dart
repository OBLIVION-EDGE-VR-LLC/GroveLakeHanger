/// Pre-allocated object pool. Zero allocation during checkout/checkin.
/// All objects are created at construction time via [factory].
/// On checkin, [reset] is called to return the object to a clean state.
class ObjectPool<T> {
  final int capacity;
  final T Function() _factory;
  final void Function(T) _reset;
  final List<T> _pool;
  int _available;

  ObjectPool({
    required this.capacity,
    required T Function() factory,
    required void Function(T) reset,
  })  : _factory = factory,
        _reset = reset,
        _pool = List<T>.generate(capacity, (_) => factory()),
        _available = capacity;

  int get available => _available;

  T checkout() {
    if (_available == 0) {
      throw StateError('ObjectPool exhausted: capacity=$capacity');
    }
    _available--;
    return _pool[_available];
  }

  void checkin(T item) {
    if (_available >= capacity) {
      throw StateError('ObjectPool overflow: item returned to full pool');
    }
    _reset(item);
    _pool[_available] = item;
    _available++;
  }
}
