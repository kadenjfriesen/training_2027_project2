import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'userButtons.dart';

//small team info at the bottom of the screen
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

//list of scouted info
class ScoutedInfo extends ConsumerWidget {
  const ScoutedInfo ({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreState = ref.watch(scoring);
    final getName = ref.watch(teamNameProvider);
    final teamNum = ref.watch(teamNumberProvider);
    final gameNum = ref.watch(gameNumberProvider);
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text('Auto score: ${scoreState.autoScore}'),
              SizedBox(height: 20),
              Text('Teleop score: ${scoreState.teleScore}'),
              SizedBox(height: 20,),
              Text('Total scored: ${scoreState.totalScore}'),
            ],
          ),
          SizedBox(width: 50,),
         Column(
           children: [
             Text('Team name: $getName'),
             SizedBox(height: 20,),
             Text('Team number: ${teamNum == 0 ? "" : teamNum}'),
             SizedBox(height: 20,),
             Text('Game number: ${gameNum == 0 ? "" : gameNum}'),
           ],
         )
        ],
      ),
    ],
    );
  }
}