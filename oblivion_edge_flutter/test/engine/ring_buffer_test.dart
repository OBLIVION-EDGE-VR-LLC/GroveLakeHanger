import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/ring_buffer.dart';

void main() {
  group('RingBuffer', () {
    test('starts empty', () {
      final buf = RingBuffer<int>(capacity: 4);
      expect(buf.isEmpty, true);
      expect(buf.isFull, false);
      expect(buf.length, 0);
    });

    test('write and read single item', () {
      final buf = RingBuffer<int>(capacity: 4);
      buf.write(42);
      expect(buf.length, 1);
      expect(buf.read(), 42);
      expect(buf.isEmpty, true);
    });

    test('FIFO ordering', () {
      final buf = RingBuffer<int>(capacity: 4);
      buf.write(1);
      buf.write(2);
      buf.write(3);
      expect(buf.read(), 1);
      expect(buf.read(), 2);
      expect(buf.read(), 3);
    });

    test('wraps around when full, drops oldest', () {
      final buf = RingBuffer<int>(capacity: 3);
      buf.write(1);
      buf.write(2);
      buf.write(3);
      expect(buf.isFull, true);
      buf.write(4); // overwrites 1
      expect(buf.read(), 2);
      expect(buf.read(), 3);
      expect(buf.read(), 4);
    });

    test('read from empty returns null', () {
      final buf = RingBuffer<int>(capacity: 2);
      expect(buf.read(), isNull);
    });

    test('drainAll returns all items in order', () {
      final buf = RingBuffer<int>(capacity: 4);
      buf.write(10);
      buf.write(20);
      buf.write(30);
      final items = buf.drainAll();
      expect(items, [10, 20, 30]);
      expect(buf.isEmpty, true);
    });
  });
}
