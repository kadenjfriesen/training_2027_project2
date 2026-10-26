import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//a little logo at the bottom to show that our team made the app
class PeopleIcon extends StatelessWidget {
  final String name;

  const PeopleIcon({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(children: [const Icon(Icons.groups), Text(name)]);
  }
}

//info down at the bottom
final reefscapeScouting = Provider<String>((ref) {
  return 'Reefscape Scouting App. Copyright 2026';
});


class NameOfApp extends ConsumerWidget {
  const NameOfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(reefscapeScouting);
    return Text(title);
  }
}

//light mode and dark mode button
class LightDarkNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }
}

final lightDark = NotifierProvider<LightDarkNotifier, bool>(() {
  return LightDarkNotifier();
});

class OnOffSwitch extends ConsumerWidget {
  const OnOffSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(lightDark);
    return IconButton(
      onPressed: () {
        ref.read(lightDark.notifier).toggle();
      },
      icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
    );
  }
}

//buttons for scoring
class ScoringState {
  final int teleScore;
  final int manualScore;
  const ScoringState({required this.teleScore, required this.manualScore});
  int get totalScore => teleScore + manualScore;
}

class ScoringNotifier extends Notifier<ScoringState> {
  @override
  ScoringState build(){
    return const ScoringState(teleScore: 0, manualScore: 0);
  }
  void add(int points) {
    final isTele = ref.read(teleManProvider);
    if(isTele) {
      state = ScoringState(
        teleScore: state.teleScore + points,
        manualScore: state.manualScore,
      );
    } else {
      state = ScoringState(
        teleScore: state.teleScore,
        manualScore: state.manualScore + points,
      );
    }
  }
}

final scoring = NotifierProvider<ScoringNotifier, ScoringState>((){
  return ScoringNotifier();
});

class ScoringButton extends ConsumerWidget {
  final String label;
  final int pointValue;

const ScoringButton({
  super.key,
  required this.label,
  required this.pointValue,
});

  @override

  Widget build(BuildContext context, WidgetRef ref) {
    final scoreValue = ref.watch(scoring);

    return ElevatedButton(onPressed: () {
      ref.read(scoring.notifier).add(pointValue);
    },
      child: Text('$label: $pointValue points'),
    );
  }
}

//segmented button for teleop and manual scoring
class TeleManNotifier extends Notifier<bool> {
  @override
  bool build () {
    return true;
  }
  void updateMode(bool value) {
    state = value;
  }
}

final teleManProvider = NotifierProvider<TeleManNotifier, bool>((){
  return TeleManNotifier();
});

class ModeButton extends ConsumerWidget {
  const ModeButton ({super.key});
  @override
Widget build(BuildContext context, WidgetRef ref) {
    final isTele = ref.watch(teleManProvider);

    return SegmentedButton<bool>(
      segments: const <ButtonSegment<bool>>[
        ButtonSegment<bool>(
        value: true,
        label: Text('Tele'),
    ),
      ButtonSegment<bool>(
        value: false,
        label: Text('Manual'),
      )
    ],
      selected: <bool>{isTele},
      onSelectionChanged: (Set<bool> newSelection) {
        ref.read(teleManProvider.notifier).updateMode(newSelection.first);
      },
    );
  }
}