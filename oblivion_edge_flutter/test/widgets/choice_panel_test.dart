import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oblivion_edge_flight/models/mission_data.dart';
import 'package:oblivion_edge_flight/widgets/choice_panel.dart';

void main() {
  group('ChoicePanel', () {
    testWidgets('displays prompt and all options', (tester) async {
      final choicePoint = ChoicePoint(
        id: 'test',
        triggerAfterPhase: 'phase_1',
        prompt: 'What do you do?',
        options: [
          ChoiceOption(
            id: 'a',
            label: 'Option A',
            description: 'Description A',
            consequences: ChoiceConsequence(),
          ),
          ChoiceOption(
            id: 'b',
            label: 'Option B',
            description: 'Description B',
            consequences: ChoiceConsequence(),
          ),
        ],
      );

      String? selected;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChoicePanel(
            choicePoint: choicePoint,
            onChoiceSelected: (id) => selected = id,
          ),
        ),
      ));

      expect(find.text('What do you do?'), findsOneWidget);
      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);

      await tester.tap(find.text('Option A'));
      await tester.pump();
      expect(selected, 'a');
    });
  });
}
