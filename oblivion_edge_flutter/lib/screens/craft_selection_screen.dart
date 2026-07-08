import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../theme/oblivion_theme.dart';
import 'game_screen.dart';

class CraftSelectionScreen extends StatefulWidget {
  const CraftSelectionScreen({Key? key}) : super(key: key);

  @override
  State<CraftSelectionScreen> createState() => _CraftSelectionScreenState();
}

class _CraftSelectionScreenState extends State<CraftSelectionScreen> {
  late String _selectedCraft;

  @override
  void initState() {
    super.initState();
    _selectedCraft =
        context.read<GameStateModel>().selectedCraft;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OblivionTheme.darkBackground,
      appBar: AppBar(
        title: const Text('SELECT YOUR CRAFT'),
        centerTitle: true,
        backgroundColor: OblivionTheme.darkGray,
        foregroundColor: OblivionTheme.primaryCyan,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Craft Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 16,
                ),
                itemCount: CraftModel.allCrafts.length,
                itemBuilder: (context, index) {
                  final craft = CraftModel.allCrafts[index];
                  final isSelected = _selectedCraft == craft.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCraft = craft.id;
                      });
                    },
                    child: CraftCard(
                      craft: craft,
                      isSelected: isSelected,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Start Button
              ElevatedButton(
                onPressed: () {
                  context.read<GameStateModel>().setSelectedCraft(_selectedCraft);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  backgroundColor: OblivionTheme.primaryCyan,
                ),
                child: Text(
                  'LAUNCH MISSION',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: OblivionTheme.darkBackground,
                        fontSize: 16,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CraftCard extends StatelessWidget {
  final CraftModel craft;
  final bool isSelected;

  const CraftCard({
    Key? key,
    required this.craft,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? OblivionTheme.secondaryGold
              : OblivionTheme.primaryCyan.withOpacity(0.3),
          width: isSelected ? 3 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: OblivionTheme.darkGray,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: OblivionTheme.primaryCyan.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Craft Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  craft.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isSelected
                            ? OblivionTheme.secondaryGold
                            : OblivionTheme.primaryCyan,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _difficultyColor(craft.difficulty),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  craft.difficulty.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 10,
                        color: OblivionTheme.darkBackground,
                      ),
                ),
              ),
            ],
          ),

          // Description
          Text(
            craft.description,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatWidget(
                  label: 'SPEED',
                  value: craft.speed,
                  maxValue: 10,
                ),
                _StatWidget(
                  label: 'AGILITY',
                  value: craft.agility,
                  maxValue: 10,
                ),
                _StatWidget(
                  label: 'ARMOR',
                  value: craft.armor,
                  maxValue: 10,
                ),
              ],
            ),
          ),

          // Selection Indicator
          if (isSelected)
            Center(
              child: Text(
                '✓ SELECTED',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: OblivionTheme.secondaryGold,
                      fontSize: 12,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return OblivionTheme.neonGreen;
      case 'medium':
        return OblivionTheme.secondaryGold;
      case 'hard':
        return OblivionTheme.orangeAccent;
      default:
        return OblivionTheme.primaryCyan;
    }
  }
}

class _StatWidget extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;

  const _StatWidget({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value / maxValue,
              backgroundColor: OblivionTheme.darkBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                value >= 7
                    ? OblivionTheme.neonGreen
                    : value >= 5
                        ? OblivionTheme.secondaryGold
                        : OblivionTheme.orangeAccent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value/$maxValue',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 9,
              ),
        ),
      ],
    );
  }
}
