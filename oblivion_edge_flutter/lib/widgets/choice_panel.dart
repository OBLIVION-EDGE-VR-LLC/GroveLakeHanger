import 'package:flutter/material.dart';
import '../models/mission_data.dart';
import '../theme/oblivion_theme.dart';

class ChoicePanel extends StatelessWidget {
  final ChoicePoint choicePoint;
  final void Function(String choiceId) onChoiceSelected;

  const ChoicePanel({
    Key? key,
    required this.choicePoint,
    required this.onChoiceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OblivionTheme.darkBackground.withOpacity(0.95),
        border: Border.all(color: OblivionTheme.secondaryGold, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DECISION POINT',
            style: TextStyle(
              color: OblivionTheme.secondaryGold,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            choicePoint.prompt,
            style: const TextStyle(
              color: OblivionTheme.lightGray,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ...choicePoint.options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => onChoiceSelected(option.id),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: OblivionTheme.primaryCyan.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: OblivionTheme.darkGray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.label,
                          style: const TextStyle(
                            color: OblivionTheme.primaryCyan,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option.description,
                          style: TextStyle(
                            color: OblivionTheme.lightGray.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
