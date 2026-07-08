import 'package:flutter/services.dart';

class GodotBridge {
  static const platform = MethodChannel('com.oblivionedge/godot');

  // Start game with selected craft
  static Future<bool> startGame({
    required String craftType,
    required String difficulty,
    required String graphicsQuality,
  }) async {
    try {
      final bool result = await platform.invokeMethod('startGame', {
        'craft': craftType,
        'difficulty': difficulty,
        'graphicsQuality': graphicsQuality,
      });
      return result;
    } on PlatformException catch (e) {
      print("Error starting game: ${e.message}");
      return false;
    }
  }

  // Pause game
  static Future<void> pauseGame() async {
    try {
      await platform.invokeMethod('pauseGame');
    } on PlatformException catch (e) {
      print("Error pausing game: ${e.message}");
    }
  }

  // Resume game
  static Future<void> resumeGame() async {
    try {
      await platform.invokeMethod('resumeGame');
    } on PlatformException catch (e) {
      print("Error resuming game: ${e.message}");
    }
  }

  // Toggle camera (1st/3rd person)
  static Future<void> toggleCamera() async {
    try {
      await platform.invokeMethod('toggleCamera');
    } on PlatformException catch (e) {
      print("Error toggling camera: ${e.message}");
    }
  }

  // Get current game state (for HUD)
  static Future<Map<dynamic, dynamic>> getGameState() async {
    try {
      final Map<dynamic, dynamic> result =
          await platform.invokeMethod('getGameState');
      return result;
    } on PlatformException catch (e) {
      print("Error getting game state: ${e.message}");
      return {};
    }
  }
}
