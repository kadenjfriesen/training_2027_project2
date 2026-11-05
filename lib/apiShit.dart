import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

const tbaApiKey = String.fromEnvironment('TBA_API_KEY',);

final teamProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, number) async {
final response = await http.get(
Uri.parse('https://www.thebluealliance.com/api/v3/team.frc$number'),
headers: {'X-TBA-Auth-Key': tbaApiKey},
);

if (response.statusCode != 200) {
  throw Exception('Failed to load team $number');
}
return jsonDecode(response.body) as Map<String, dynamic>;
});

class TeamInfo extends ConsumerWidget {
  final int teamNumber;

  const TeamInfo({super.key, required this.teamNumber});

  @override
Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider(teamNumber));

    return team.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (data) => Column(
        children: [
          Text('${data['team_number']}'),
          Text(data['nickname'] ?? 'Unknown'),
        ],
      )
    );
}
}