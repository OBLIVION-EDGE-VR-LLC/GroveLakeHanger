import 'dart:async';
import 'dart:isolate';

/// A unit of work for the thread pool or process pool.
class WorkerTask {
  final String id;
  final Map<String, dynamic> input;
  Map<String, dynamic>? result;

  WorkerTask({required this.id, required this.input});
}

/// Simulated thread pool using Dart's event loop for lightweight parallel tasks.
/// In Dart, true threads aren't available, so we use Future.wait for concurrency
/// within the main isolate. For CPU-heavy work, use ProcessPool (Isolates).
class ThreadPool {
  final int workerCount;
  bool _initialized = false;

  /// Register worker functions by task id.
  final Map<String, Future<Map<String, dynamic>> Function(Map<String, dynamic> input, Map<String, Map<String, dynamic>> snapshot)>
      _workers = {};

  ThreadPool({this.workerCount = 4});

  void init() {
    _initialized = true;
  }

  /// Register a named worker function.
  void registerWorker(
    String taskId,
    Future<Map<String, dynamic>> Function(
            Map<String, dynamic> input, Map<String, Map<String, dynamic>> snapshot)
        worker,
  ) {
    _workers[taskId] = worker;
  }

  /// Submit all tasks, execute up to [workerCount] concurrently, wait for all.
  Future<void> submitAll(
    List<WorkerTask> tasks,
    Map<String, Map<String, dynamic>> snapshot,
  ) async {
    if (!_initialized) throw StateError('ThreadPool not initialized');

    final futures = <Future<void>>[];
    for (final task in tasks) {
      final worker = _workers[task.id];
      if (worker != null) {
        futures.add(
          worker(task.input, snapshot).then((result) {
            task.result = result;
          }),
        );
      } else {
        // Default: echo input as result
        task.result = Map<String, dynamic>.from(task.input);
      }
    }
    await Future.wait(futures);
  }

  void dispose() {
    _initialized = false;
    _workers.clear();
  }
}

/// Process pool using Dart Isolates for CPU-heavy compute.
/// Results are non-blocking: submit work, check for results next frame.
class ProcessPool {
  final int maxProcesses;
  final Map<String, Isolate> _isolates = {};
  final Map<String, ReceivePort> _ports = {};
  final Map<String, Map<String, dynamic>?> _results = {};
  bool _initialized = false;

  /// Register isolate entry points by task id.
  final Map<String, void Function(SendPort)> _entryPoints = {};

  ProcessPool({this.maxProcesses = 2});

  Future<void> init() async {
    _initialized = true;
  }

  /// Register a named isolate worker.
  void registerIsolateWorker(String taskId, void Function(SendPort) entryPoint) {
    _entryPoints[taskId] = entryPoint;
  }

  /// Submit work to an isolate. Non-blocking — result arrives later.
  void submitIsolate(String id, Map<String, dynamic> input) {
    if (!_initialized) throw StateError('ProcessPool not initialized');

    _results[id] = null; // mark as pending

    final receivePort = ReceivePort();
    _ports[id] = receivePort;

    final entryPoint = _entryPoints[id];
    if (entryPoint != null) {
      Isolate.spawn((sendPort) {
        entryPoint(sendPort);
      }, receivePort.sendPort).then((isolate) {
        _isolates[id] = isolate;
      });
    } else {
      // Default: echo input as result after a microtask
      Future.microtask(() {
        _results[id] = Map<String, dynamic>.from(input);
      });
    }

    receivePort.listen((message) {
      if (message is Map<String, dynamic>) {
        _results[id] = message;
      }
    });
  }

  /// Non-blocking check for result. Returns null if not ready.
  Map<String, dynamic>? tryGetResult(String id) {
    return _results[id];
  }

  /// Clear a completed result.
  void clearResult(String id) {
    _results.remove(id);
    _ports[id]?.close();
    _ports.remove(id);
    _isolates[id]?.kill();
    _isolates.remove(id);
  }

  Future<void> dispose() async {
    for (final port in _ports.values) {
      port.close();
    }
    for (final isolate in _isolates.values) {
      isolate.kill();
    }
    _ports.clear();
    _isolates.clear();
    _results.clear();
    _initialized = false;
  }
}

/// Top-level concurrency manager. Owns thread pool and process pool.
class ConcurrencyManager {
  final int threadCount;
  final int processCount;
  late final ThreadPool threadPool;
  late final ProcessPool processPool;

  ConcurrencyManager({this.threadCount = 4, this.processCount = 2});

  Future<void> init() async {
    threadPool = ThreadPool(workerCount: threadCount);
    threadPool.init();
    processPool = ProcessPool(maxProcesses: processCount);
    await processPool.init();
  }

  Future<void> dispose() async {
    threadPool.dispose();
    await processPool.dispose();
  }
}
