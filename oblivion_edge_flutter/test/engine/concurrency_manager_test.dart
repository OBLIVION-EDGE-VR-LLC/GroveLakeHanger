import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/engine/concurrency_manager.dart';

void main() {
  group('WorkerTask', () {
    test('creates with id and input', () {
      final task = WorkerTask(id: 'physics', input: {'x': 1.0, 'y': 2.0});
      expect(task.id, 'physics');
      expect(task.input['x'], 1.0);
      expect(task.result, isNull);
    });

    test('result can be set', () {
      final task = WorkerTask(id: 'test', input: {});
      task.result = {'computed': true};
      expect(task.result!['computed'], true);
    });
  });

  group('ThreadPool', () {
    test('submitAll processes tasks and sets results', () async {
      final pool = ThreadPool(workerCount: 2);
      pool.init();

      final tasks = [
        WorkerTask(id: 'add', input: {'a': 3, 'b': 4}),
        WorkerTask(id: 'add', input: {'a': 10, 'b': 20}),
      ];

      await pool.submitAll(tasks, {});

      expect(tasks[0].result, isNotNull);
      expect(tasks[1].result, isNotNull);

      pool.dispose();
    });
  });

  group('ProcessPool', () {
    test('submitIsolate and tryGetResult for heavy compute', () async {
      final pool = ProcessPool(maxProcesses: 2);
      await pool.init();

      pool.submitIsolate('slam', {'coverage': 0.5});

      // Give isolate time to process
      await Future.delayed(const Duration(milliseconds: 100));

      final result = pool.tryGetResult('slam');
      expect(result, isNotNull);

      await pool.dispose();
    });

    test('tryGetResult returns null when not ready', () async {
      final pool = ProcessPool(maxProcesses: 1);
      await pool.init();

      final result = pool.tryGetResult('nonexistent');
      expect(result, isNull);

      await pool.dispose();
    });
  });

  group('ConcurrencyManager', () {
    test('init creates thread and process pools', () async {
      final mgr = ConcurrencyManager(threadCount: 2, processCount: 1);
      await mgr.init();

      expect(mgr.threadPool, isNotNull);
      expect(mgr.processPool, isNotNull);

      await mgr.dispose();
    });
  });
}
