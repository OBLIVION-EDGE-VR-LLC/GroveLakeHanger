import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/object_pool.dart';

void main() {
  group('ObjectPool', () {
    test('creates pool with specified capacity', () {
      final pool = ObjectPool<List<int>>(
        capacity: 4,
        factory: () => <int>[],
        reset: (list) => list.clear(),
      );
      expect(pool.capacity, 4);
      expect(pool.available, 4);
    });

    test('checkout returns an object and decrements available', () {
      final pool = ObjectPool<List<int>>(
        capacity: 2,
        factory: () => <int>[],
        reset: (list) => list.clear(),
      );
      final obj = pool.checkout();
      expect(obj, isA<List<int>>());
      expect(pool.available, 1);
    });

    test('checkin returns object to pool and resets it', () {
      final pool = ObjectPool<List<int>>(
        capacity: 2,
        factory: () => <int>[],
        reset: (list) => list.clear(),
      );
      final obj = pool.checkout();
      obj.add(42);
      pool.checkin(obj);
      expect(pool.available, 2);
      final obj2 = pool.checkout();
      expect(obj2, isEmpty);
    });

    test('throws when pool is exhausted', () {
      final pool = ObjectPool<List<int>>(
        capacity: 1,
        factory: () => <int>[],
        reset: (list) => list.clear(),
      );
      pool.checkout();
      expect(() => pool.checkout(), throwsStateError);
    });
  });
}
