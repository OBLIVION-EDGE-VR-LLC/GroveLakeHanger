/// Fixed-capacity ring buffer with backpressure (drops oldest on overflow).
/// Pre-allocates slot list at construction. Zero allocation during write/read.
class RingBuffer<T> {
  final int capacity;
  final List<T?> _slots;
  int _head = 0; // next read position
  int _tail = 0; // next write position
  int _length = 0;

  RingBuffer({required this.capacity}) : _slots = List<T?>.filled(capacity, null);

  bool get isEmpty => _length == 0;
  bool get isFull => _length == capacity;
  int get length => _length;

  void write(T item) {
    if (_length == capacity) {
      // Backpressure: drop oldest
      _head = (_head + 1) % capacity;
      _length--;
    }
    _slots[_tail] = item;
    _tail = (_tail + 1) % capacity;
    _length++;
  }

  T? read() {
    if (_length == 0) return null;
    final item = _slots[_head];
    _slots[_head] = null;
    _head = (_head + 1) % capacity;
    _length--;
    return item;
  }

  List<T> drainAll() {
    final result = <T>[];
    while (_length > 0) {
      result.add(read() as T);
    }
    return result;
  }
}
