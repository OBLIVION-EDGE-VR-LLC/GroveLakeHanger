import 'package:flutter/foundation.dart';

class GameStateModel extends ChangeNotifier {
  String _selectedCraft = 'sentinel_orb';
  String _gameDifficulty = 'normal';
  String _graphicsQuality = 'high';
  bool _isGameRunning = false;

  // Game telemetry (from Godot)
  double _altitude = 0.0;
  double _speed = 0.0;
  double _health = 100.0;
  String _cameraMode = '3rd_person';

  // Getters
  String get selectedCraft => _selectedCraft;
  String get gameDifficulty => _gameDifficulty;
  String get graphicsQuality => _graphicsQuality;
  bool get isGameRunning => _isGameRunning;
  double get altitude => _altitude;
  double get speed => _speed;
  double get health => _health;
  String get cameraMode => _cameraMode;

  // Setters
  void setSelectedCraft(String craft) {
    _selectedCraft = craft;
    notifyListeners();
  }

  void setGameDifficulty(String difficulty) {
    _gameDifficulty = difficulty;
    notifyListeners();
  }

  void setGraphicsQuality(String quality) {
    _graphicsQuality = quality;
    notifyListeners();
  }

  void setGameRunning(bool running) {
    _isGameRunning = running;
    notifyListeners();
  }

  void updateTelemetry({
    required double altitude,
    required double speed,
    required double health,
  }) {
    _altitude = altitude;
    _speed = speed;
    _health = health;
    notifyListeners();
  }

  void setCameraMode(String mode) {
    _cameraMode = mode;
    notifyListeners();
  }

  void reset() {
    _selectedCraft = 'sentinel_orb';
    _gameDifficulty = 'normal';
    _graphicsQuality = 'high';
    _isGameRunning = false;
    _altitude = 0.0;
    _speed = 0.0;
    _health = 100.0;
    _cameraMode = '3rd_person';
    _reputationScores = {'patriot': 0, 'grey': 0, 'hacker': 0};
    _handlerTrust = 5;
    _narrativeFlags.clear();
    _completedMissionIds.clear();
    _unlockedMissions.clear();
    _lockedMissions.clear();
    _currentAct = 'grove_lake';
    _skillLevels.clear();
    notifyListeners();
  }

  // --- Narrative & Consequence State ---
  Map<String, int> _reputationScores = {'patriot': 0, 'grey': 0, 'hacker': 0};
  int _handlerTrust = 5;
  final Set<String> _narrativeFlags = {};
  final List<String> _completedMissionIds = [];
  final Set<String> _unlockedMissions = {};
  final Set<String> _lockedMissions = {};
  String _currentAct = 'grove_lake';
  final Map<String, int> _skillLevels = {};

  Map<String, int> get reputationScores => Map.unmodifiable(_reputationScores);
  int get handlerTrust => _handlerTrust;
  Set<String> get narrativeFlags => Set.unmodifiable(_narrativeFlags);
  List<String> get completedMissionIds => List.unmodifiable(_completedMissionIds);
  Set<String> get unlockedMissions => Set.unmodifiable(_unlockedMissions);
  Set<String> get lockedMissions => Set.unmodifiable(_lockedMissions);
  String get currentAct => _currentAct;
  Map<String, int> get skillLevels => Map.unmodifiable(_skillLevels);

  void addReputation(String path, int delta) {
    _reputationScores[path] = (_reputationScores[path] ?? 0) + delta;
    notifyListeners();
  }

  void adjustHandlerTrust(int delta) {
    _handlerTrust += delta;
    notifyListeners();
  }

  void addNarrativeFlag(String flag) {
    if (flag.isNotEmpty) {
      _narrativeFlags.add(flag);
      notifyListeners();
    }
  }

  void completeMission(String missionId) {
    _completedMissionIds.add(missionId);
    notifyListeners();
  }

  void unlockMission(String missionId) {
    _lockedMissions.remove(missionId);
    _unlockedMissions.add(missionId);
    notifyListeners();
  }

  void lockMission(String missionId) {
    _unlockedMissions.remove(missionId);
    _lockedMissions.add(missionId);
    notifyListeners();
  }

  void setCurrentAct(String act) {
    _currentAct = act;
    notifyListeners();
  }

  void setSkillLevel(String skill, int level) {
    _skillLevels[skill] = level;
    notifyListeners();
  }

  int getSkillLevel(String skill) => _skillLevels[skill] ?? 0;
}

// Craft data model
class CraftModel {
  final String id;
  final String name;
  final String description;
  final int speed;
  final int agility;
  final int armor;
  final String difficulty;
  final String colorHex;

  CraftModel({
    required this.id,
    required this.name,
    required this.description,
    required this.speed,
    required this.agility,
    required this.armor,
    required this.difficulty,
    required this.colorHex,
  });

  static final List<CraftModel> allCrafts = [
    CraftModel(
      id: 'sentinel_orb',
      name: 'Sentinel Orb',
      description: 'Balanced ORB with standard thrust configuration',
      speed: 6,
      agility: 6,
      armor: 6,
      difficulty: 'easy',
      colorHex: '#FFD700',
    ),
    CraftModel(
      id: 'vortex_fighter',
      name: 'Vortex Fighter',
      description: 'Classified delta platform with MHD propulsion — no moving parts',
      speed: 9,
      agility: 8,
      armor: 3,
      difficulty: 'hard',
      colorHex: '#00CED1',
    ),
    CraftModel(
      id: 'titan_carrier',
      name: 'Titan Carrier',
      description: '40-foot armored disc with plasma membrane shield generator',
      speed: 3,
      agility: 3,
      armor: 10,
      difficulty: 'easy',
      colorHex: '#8B0000',
    ),
    CraftModel(
      id: 'phantom_interceptor',
      name: 'Phantom Interceptor',
      description: 'Stealthy angular craft with cloaking field',
      speed: 7,
      agility: 9,
      armor: 5,
      difficulty: 'medium',
      colorHex: '#00FF00',
    ),
    CraftModel(
      id: 'prism_nexus',
      name: 'Prism Nexus',
      description: 'Crystalline multi-faceted craft with scanner',
      speed: 5,
      agility: 5,
      armor: 6,
      difficulty: 'medium',
      colorHex: '#FF69B4',
    ),
  ];
}
