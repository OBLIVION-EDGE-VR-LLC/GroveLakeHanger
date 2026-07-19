import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/asset_registry.dart';

void main() {
  group('AssetRegistry', () {
    test('register and retrieve flyweight asset', () {
      final registry = AssetRegistry();
      registry.register<String>('manta_ray_desc', 'BWB 6ft SLAM Mapper');
      expect(registry.get<String>('manta_ray_desc'), 'BWB 6ft SLAM Mapper');
    });

    test('has returns true for registered assets', () {
      final registry = AssetRegistry();
      registry.register<int>('wingspan', 1829);
      expect(registry.has('wingspan'), true);
      expect(registry.has('missing'), false);
    });

    test('get returns null for missing asset', () {
      final registry = AssetRegistry();
      expect(registry.get<String>('nope'), isNull);
    });

    test('clear removes all assets', () {
      final registry = AssetRegistry();
      registry.register<String>('a', 'val');
      registry.clear();
      expect(registry.has('a'), false);
    });
  });

  group('AssetProxy', () {
    test('lazy loads on first get()', () {
      final registry = AssetRegistry();
      registry.register<String>('fact1', 'SLAM builds 3D maps');
      final proxy = AssetProxy<String>(key: 'fact1', registry: registry);

      expect(proxy.isLoaded, false);
      expect(proxy.get(), 'SLAM builds 3D maps');
      expect(proxy.isLoaded, true);
    });

    test('release clears loaded state', () {
      final registry = AssetRegistry();
      registry.register<String>('fact2', 'BWB has low RCS');
      final proxy = AssetProxy<String>(key: 'fact2', registry: registry);

      proxy.get();
      expect(proxy.isLoaded, true);
      proxy.release();
      expect(proxy.isLoaded, false);
    });

    test('get after release reloads from registry', () {
      final registry = AssetRegistry();
      registry.register<String>('fact3', 'Elevon control');
      final proxy = AssetProxy<String>(key: 'fact3', registry: registry);

      proxy.get();
      proxy.release();
      expect(proxy.get(), 'Elevon control');
      expect(proxy.isLoaded, true);
    });
  });
}
