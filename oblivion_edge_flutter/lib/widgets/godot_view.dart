import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GodotView extends StatefulWidget {
  final String craftId;
  final String difficulty;
  final String graphicsQuality;

  const GodotView({
    Key? key,
    required this.craftId,
    required this.difficulty,
    required this.graphicsQuality,
  }) : super(key: key);

  @override
  State<GodotView> createState() => _GodotViewState();
}

class _GodotViewState extends State<GodotView> {
  static const platform = MethodChannel('com.oblivionedge/godot');
  bool _godotReady = false;
  Map<String, dynamic> _gameState = {};

  @override
  void initState() {
    super.initState();
    _initializeGodot();
  }

  Future<void> _initializeGodot() async {
    try {
      print('[Flutter] Initializing Godot with craft: ${widget.craftId}');

      // Start the Godot game
      final bool result = await platform.invokeMethod('startGame', {
        'craft': widget.craftId,
        'difficulty': widget.difficulty,
        'graphicsQuality': widget.graphicsQuality,
      });

      if (result) {
        setState(() {
          _godotReady = true;
        });
        print('[Flutter] Godot initialized successfully!');
        _startTelemetryUpdates();
      }
    } on PlatformException catch (e) {
      print('[Flutter] Error initializing Godot: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start game: ${e.message}')),
      );
    }
  }

  void _startTelemetryUpdates() {
    // Poll telemetry every 100ms
    Future.delayed(const Duration(milliseconds: 100), () async {
      if (!mounted) return;

      try {
        final state = await platform.invokeMethod('getGameState');
        if (state is Map) {
          setState(() {
            _gameState = Map<String, dynamic>.from(state);
          });
        }
      } catch (e) {
        print('[Flutter] Error getting game state: $e');
      }

      // Keep polling
      _startTelemetryUpdates();
    });
  }

  Future<void> toggleCamera() async {
    try {
      await platform.invokeMethod('toggleCamera');
    } catch (e) {
      print('[Flutter] Error toggling camera: $e');
    }
  }

  Future<void> pauseGame() async {
    try {
      await platform.invokeMethod('pauseGame');
    } catch (e) {
      print('[Flutter] Error pausing game: $e');
    }
  }

  Future<void> resumeGame() async {
    try {
      await platform.invokeMethod('resumeGame');
    } catch (e) {
      print('[Flutter] Error resuming game: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Godot render view (placeholder until native integration)
        Container(
          color: Colors.black,
          child: Center(
            child: _godotReady
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '🛸 GODOT ENGINE RENDERING 🛸',
                        style: TextStyle(
                          color: Color(0xFF00CED1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Flight Simulator Active',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF00CED1)),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Initializing Godot Engine...',
                        style: TextStyle(
                          color: Color(0xFF00CED1),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        // HUD Overlay - Telemetry Display
        if (_godotReady)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top-left: Craft & Status
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00CED1), width: 1),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CRAFT: ${widget.craftId.replaceAll('_', ' ').toUpperCase()}',
                        style: const TextStyle(
                          color: Color(0xFF00CED1),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'STATUS: ${_godotReady ? "NOMINAL" : "LOADING"}',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Bottom HUD - Flight Telemetry
        if (_godotReady)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Altitude
                _TelemetryBox(
                  label: 'ALTITUDE',
                  value:
                      '${(_gameState['altitude'] ?? 0.0).toStringAsFixed(1)}m',
                ),
                // Speed
                _TelemetryBox(
                  label: 'SPEED',
                  value:
                      '${(_gameState['speed'] ?? 0.0).toStringAsFixed(1)}m/s',
                ),
                // Health
                _TelemetryBox(
                  label: 'HEALTH',
                  value: '${(_gameState['health'] ?? 100.0).toInt()}%',
                ),
              ],
            ),
          ),

        // Camera toggle button
        if (_godotReady)
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xFF00CED1),
              onPressed: toggleCamera,
              child: const Icon(Icons.videocam),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _TelemetryBox extends StatelessWidget {
  final String label;
  final String value;

  const _TelemetryBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00CED1), width: 1),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00CED1),
              fontSize: 9,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
