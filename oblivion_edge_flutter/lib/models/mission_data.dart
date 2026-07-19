class MissionPhase {
  final String id;
  final String name;
  final String briefing;
  final String character;
  final String objective;
  final List<String> educationalContent;

  const MissionPhase({
    required this.id,
    required this.name,
    required this.briefing,
    required this.character,
    required this.objective,
    this.educationalContent = const [],
  });
}

class ChoiceConsequence {
  final Map<String, int> reputationChanges;
  final int handlerTrustDelta;
  final List<String> unlocksMissions;
  final List<String> locksMissions;
  final String narrativeFlag;

  const ChoiceConsequence({
    this.reputationChanges = const {},
    this.handlerTrustDelta = 0,
    this.unlocksMissions = const [],
    this.locksMissions = const [],
    this.narrativeFlag = '',
  });
}

class ChoiceOption {
  final String id;
  final String label;
  final String description;
  final ChoiceConsequence consequences;

  const ChoiceOption({
    required this.id,
    required this.label,
    required this.description,
    required this.consequences,
  });
}

class ChoicePoint {
  final String id;
  final String triggerAfterPhase;
  final String prompt;
  final List<ChoiceOption> options;

  const ChoicePoint({
    required this.id,
    required this.triggerAfterPhase,
    required this.prompt,
    required this.options,
  });
}

class MissionData {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final List<String> pathAffinity;
  final String storyAct;
  final Map<String, int> skillRequirements;
  final int reward;
  final List<MissionPhase> phases;
  final List<ChoicePoint> choicePoints;
  final List<String> educationalFacts;

  const MissionData({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    this.pathAffinity = const [],
    this.storyAct = '',
    this.skillRequirements = const {},
    required this.reward,
    required this.phases,
    this.choicePoints = const [],
    this.educationalFacts = const [],
  });

  /// All registered missions.
  static final List<MissionData> allMissions = [];
}
