/// Flyweight store. Assets registered here are shared immutable data
/// loaded once at "cartridge boot" and referenced by many consumers.
class AssetRegistry {
  final Map<String, dynamic> _assets = {};

  void register<T>(String key, T asset) {
    _assets[key] = asset;
  }

  T? get<T>(String key) {
    return _assets[key] as T?;
  }

  bool has(String key) {
    return _assets.containsKey(key);
  }

  void clear() {
    _assets.clear();
  }
}

/// Proxy that lazy-loads an asset from the registry on first access.
/// Call release() to drop the local reference (reducing memory footprint
/// between missions). Next get() reloads from registry.
class AssetProxy<T> {
  final String key;
  final AssetRegistry registry;
  T? _cached;
  bool _isLoaded = false;

  AssetProxy({required this.key, required this.registry});

  bool get isLoaded => _isLoaded;

  T get() {
    if (!_isLoaded) {
      _cached = registry.get<T>(key);
      _isLoaded = true;
    }
    return _cached as T;
  }

  void release() {
    _cached = null;
    _isLoaded = false;
  }
}
