import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/game_state.dart';
import '../theme/oblivion_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isPaused = false;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    context.read<GameStateModel>().setGameRunning(true);

    // Initialize WebView controller
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/flight_sim.html');
  }

  @override
  void dispose() {
    context.read<GameStateModel>().setGameRunning(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showPauseMenu();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Three.js Flight Simulator in WebView
            WebViewWidget(
              controller: _webViewController,
            ),

            // Pause Button (Floating Action Button)
            Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: FloatingActionButton(
                  mini: true,
                  onPressed: _showPauseMenu,
                  backgroundColor: OblivionTheme.primaryCyan,
                  child: const Icon(Icons.pause),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHUD(BuildContext context) {
    return Consumer<GameStateModel> (
      builder: (context, gameState, _) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Column(
              children: [
                // Top HUD
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Craft Info
                      _HUDPanel(
                        children: [
                          _HUDRow('CRAFT', _craftDisplayName(gameState.selectedCraft)),
                          _HUDRow('CAMERA', gameState.cameraMode.replaceAll('_', ' ')),
                        ],
                      ),
                      // Right: Status
                      _HUDPanel(
                        children: [
                          _HUDRow('HEALTH', '${gameState.health.toStringAsFixed(0)}%'),
                          _HUDRow('STATUS', 'NOMINAL'),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom HUD
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _HUDPanel(
                        children: [
                          _HUDRow('ALTITUDE', '${gameState.altitude.toStringAsFixed(1)}m'),
                          _HUDRow('CLIMB RATE', '0.0 m/s'),
                        ],
                      ),
                      _HUDPanel(
                        children: [
                          _HUDRow('SPEED', '${gameState.speed.toStringAsFixed(1)} m/s'),
                          _HUDRow('THROTTLE', '0%'),
                        ],
                      ),
                      _HUDPanel(
                        children: [
                          _HUDRow('HEADING', '000°'),
                          _HUDRow('PITCH', '0°'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPauseMenu() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: OblivionTheme.darkGray,
          title: Text(
            'MISSION PAUSED',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          content: Text(
            'Select an option',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isPaused = false;
                });
              },
              child: Text(
                'RESUME',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text(
                'EXIT',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: OblivionTheme.orangeAccent),
              ),
            ),
          ],
        ),
      ).then((_) {
        setState(() {
          _isPaused = false;
        });
      });
    }
  }

  String _craftDisplayName(String id) {
    return CraftModel.allCrafts
            .firstWhere((c) => c.id == id, orElse: () => CraftModel.allCrafts[0])
            .name ??
        'UNKNOWN';
  }
}

class _HUDPanel extends StatelessWidget {
  final List<Widget> children;

  const _HUDPanel({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: OblivionTheme.primaryCyan,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _HUDRow extends StatelessWidget {
  final String label;
  final String value;

  const _HUDRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: OblivionTheme.primaryCyan,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: OblivionTheme.secondaryGold,
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
