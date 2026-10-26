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
class ScoringNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }
    void add(int points) {
      state += points;
    }
}

final scoring = NotifierProvider<ScoringNotifier, int>(() {
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