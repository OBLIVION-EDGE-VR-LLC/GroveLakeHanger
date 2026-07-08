import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'screens/home_screen.dart';
import 'theme/oblivion_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OblivionEdgeApp());
}

class OblivionEdgeApp extends StatelessWidget {
  const OblivionEdgeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameStateModel()),
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
