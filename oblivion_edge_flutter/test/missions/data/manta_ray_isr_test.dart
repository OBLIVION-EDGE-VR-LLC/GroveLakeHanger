import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/missions/data/manta_ray_isr.dart';
import 'package:oblivion_edge_flight/missions/mission_adapter.dart';

void main() {
  group('MantaRayIsr', () {
    test('mission has correct id and metadata', () {
      final m = MantaRayIsr.mission;
      expect(m.id, 'manta_ray_isr');
      expect(m.name, 'Silent Wings');
      expect(m.difficulty, 'medium');
      expect(m.storyAct, 'isr_sigint');
      expect(m.reward, 1200);
    });

    test('mission has two phases', () {
      final m = MantaRayIsr.mission;
      expect(m.phases.length, 2);
      expect(m.phases[0].id, 'slam_pass');
      expect(m.phases[1].id, 'sigint_pass');
    });

    test('choice point triggers after slam_pass', () {
      final m = MantaRayIsr.mission;
      expect(m.choicePoints.length, 1);
      expect(m.choicePoints[0].triggerAfterPhase, 'slam_pass');
      expect(m.choicePoints[0].options.length, 3);
    });

    test('choice A gives patriot reputation', () {
      final optA = MantaRayIsr.mission.choicePoints[0].options[0];
      expect(optA.id, 'military_only');
      expect(optA.consequences.reputationChanges['patriot'], 2);
      expect(optA.consequences.handlerTrustDelta, 1);
    });

    test('choice B gives grey reputation', () {
      final optB = MantaRayIsr.mission.choicePoints[0].options[1];
      expect(optB.id, 'full_sweep');
      expect(optB.consequences.reputationChanges['grey'], 3);
      expect(optB.consequences.handlerTrustDelta, -1);
    });

    test('choice C gives grey and hacker reputation', () {
      final optC = MantaRayIsr.mission.choicePoints[0].options[2];
      expect(optC.id, 'flag_hospital');
      expect(optC.consequences.reputationChanges['grey'], 2);
      expect(optC.consequences.reputationChanges['hacker'], 1);
      expect(optC.consequences.handlerTrustDelta, -2);
    });

    test('toLegacyMap produces valid legacy format', () {
      final legacy = MissionAdapter.toLegacyMap(MantaRayIsr.mission);
      expect(legacy['id'], 'manta_ray_isr');
      expect(legacy['name'], 'Silent Wings');
      expect(legacy['isMissionData'], true);
      expect(legacy['facts'], isA<List<String>>());
      expect((legacy['facts'] as List).isNotEmpty, true);
    });

    test('has educational facts about BWB and SLAM', () {
      final m = MantaRayIsr.mission;
      final allFacts = [
        ...m.educationalFacts,
        ...m.phases.expand((p) => p.educationalContent),
      ];
      expect(allFacts.any((f) => f.contains('SLAM')), true);
      expect(allFacts.any((f) => f.contains('BWB')), true);
    });

    test('path affinity includes all three paths', () {
      final m = MantaRayIsr.mission;
      expect(m.pathAffinity, containsAll(['patriot', 'grey', 'hacker']));
    });
  });
}
