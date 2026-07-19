import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/models/blackboard.dart';

void main() {
  group('BlackboardSection', () {
    test('write and read values', () {
      final section = BlackboardSection();
      section.write<double>('altitude', 200.0);
      expect(section.read<double>('altitude'), 200.0);
    });

    test('version increments on write', () {
      final section = BlackboardSection();
      expect(section.version, 0);
      section.write<int>('count', 1);
      expect(section.version, 1);
      section.write<int>('count', 2);
      expect(section.version, 2);
    });

    test('read returns null for missing key', () {
      final section = BlackboardSection();
      expect(section.read<String>('missing'), isNull);
    });

    test('snapshot returns copy of data', () {
      final section = BlackboardSection();
      section.write<String>('name', 'test');
      final snap = section.snapshot();
      expect(snap['name'], 'test');
      section.write<String>('name', 'changed');
      expect(snap['name'], 'test');
    });
  });

  group('Blackboard', () {
    test('has predefined sections', () {
      final bb = Blackboard();
      expect(bb.section('world'), isNotNull);
      expect(bb.section('mission'), isNotNull);
      expect(bb.section('signals'), isNotNull);
      expect(bb.section('narrative'), isNotNull);
      expect(bb.section('player'), isNotNull);
    });

    test('write to section and read back', () {
      final bb = Blackboard();
      bb.section('mission').write<double>('slamCoverage', 0.73);
      expect(bb.section('mission').read<double>('slamCoverage'), 0.73);
    });

    test('full snapshot captures all sections', () {
      final bb = Blackboard();
      bb.section('world').write<double>('droneHeading', 45.0);
      bb.section('signals').write<int>('signalCount', 3);

      final snap = bb.snapshot();
      expect(snap['world']!['droneHeading'], 45.0);
      expect(snap['signals']!['signalCount'], 3);
    });

    test('sections are isolated from each other', () {
      final bb = Blackboard();
      bb.section('world').write<String>('key', 'world_val');
      bb.section('mission').write<String>('key', 'mission_val');
      expect(bb.section('world').read<String>('key'), 'world_val');
      expect(bb.section('mission').read<String>('key'), 'mission_val');
    });
  });
}
