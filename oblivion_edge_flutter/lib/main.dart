import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'models/mission_data.dart';
import 'models/blackboard.dart';
import 'engine/game_kernel.dart';
import 'missions/data/manta_ray_isr.dart';
import 'screens/home_screen.dart';
import 'theme/oblivion_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register missions
  MissionData.allMissions.add(MantaRayIsr.mission);

  runApp(const OblivionEdgeApp());
}

class OblivionEdgeApp extends StatefulWidget {
  const OblivionEdgeApp({Key? key}) : super(key: key);

  @override
  State<OblivionEdgeApp> createState() => _OblivionEdgeAppState();
}

class _OblivionEdgeAppState extends State<OblivionEdgeApp> {
  final GameKernel _kernel = GameKernel();

  @override
  void initState() {
    super.initState();
    _kernel.init();
  }

  @override
  void dispose() {
    _kernel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameStateModel()),
        Provider<GameKernel>.value(value: _kernel),
        Provider<Blackboard>.value(value: _kernel.blackboard),
      ],
      child: MaterialApp(
        title: 'Oblivion Edge: Flight Simulator',
        theme: OblivionTheme.darkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
