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