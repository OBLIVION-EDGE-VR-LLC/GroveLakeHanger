import '../models/game_state.dart';
import '../models/mission_data.dart';

/// Reads choice consequences and applies them to GameStateModel.
/// Also checks mission availability based on skills and lock state.
class ConsequenceTracker {
  void applyConsequence(ChoiceConsequence consequence, GameStateModel state) {
    for (final entry in consequence.reputationChanges.entries) {
      state.addReputation(entry.key, entry.value);
    }
    if (consequence.handlerTrustDelta != 0) {
      state.adjustHandlerTrust(consequence.handlerTrustDelta);
    }
    if (consequence.narrativeFlag.isNotEmpty) {
      state.addNarrativeFlag(consequence.narrativeFlag);
    }
    for (final missionId in consequence.unlocksMissions) {
      state.unlockMission(missionId);
    }
    for (final missionId in consequence.locksMissions) {
      state.lockMission(missionId);
    }
  }

  bool isMissionAvailable(MissionData mission, GameStateModel state) {
    if (state.lockedMissions.contains(mission.id)) {
      return false;
    }

    for (final entry in mission.skillRequirements.entries) {
      if (state.getSkillLevel(entry.key) < entry.value) {
        return false;
      }
    }

    return true;
  }
}
