import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final int autoScore;
  final int teleScore;
  const ScoringState({required this.autoScore, required this.teleScore});
  int get totalScore => autoScore + teleScore;
}

class ScoringNotifier extends Notifier<ScoringState> {
  @override
  ScoringState build() {
    return const ScoringState(autoScore: 0, teleScore: 0);
  }

  void add(int points) {
    final isAuto = ref.read(autoTeleProvider);
    if (isAuto) {
      state = ScoringState(
        autoScore: state.autoScore + points,
        teleScore: state.teleScore,
      );
    } else {
      state = ScoringState(
        autoScore: state.autoScore,
        teleScore: state.teleScore + points,
      );
    }
  }
}

final scoring = NotifierProvider<ScoringNotifier, ScoringState>(() {
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

    return ElevatedButton(
      onPressed: () {
        ref.read(scoring.notifier).add(pointValue);
      },
      child: Text('$label: $pointValue points'),
    );
  }
}

//segmented button for teleop and auto scoring
class AutoTeleNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void updateMode(bool value) {
    state = value;
  }
}

final autoTeleProvider = NotifierProvider<AutoTeleNotifier, bool>(() {
  return AutoTeleNotifier();
});

class ModeButton extends ConsumerWidget {
  const ModeButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTele = ref.watch(autoTeleProvider);

    return SegmentedButton<bool>(
      segments: const <ButtonSegment<bool>>[
        ButtonSegment<bool>(value: true, label: Text('Auto')),
        ButtonSegment<bool>(value: false, label: Text('Teleop')),
      ],
      selected: <bool>{isTele},
      onSelectionChanged: (Set<bool> newSelection) {
        ref.read(autoTeleProvider.notifier).updateMode(newSelection.first);
      },
    );
  }
}

//team number notifier
class TeamNumberNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void update(int value) => state = value;
}
final teamNumberProvider = NotifierProvider<TeamNumberNotifier, int>(() => TeamNumberNotifier ());

//game number notifier
class GameNumberNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void update(int value) => state = value;
}
final gameNumberProvider = NotifierProvider<GameNumberNotifier, int>(() => GameNumberNotifier ());