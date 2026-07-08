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
    notifyListeners();
  }
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
      description: 'High-speed sleek UFO with boost capability',
      speed: 9,
      agility: 8,
      armor: 3,
      difficulty: 'hard',
      colorHex: '#00CED1',
    ),
    CraftModel(
      id: 'titan_carrier',
      name: 'Titan Carrier',
      description: 'Heavy armored disc with shield generator',
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
