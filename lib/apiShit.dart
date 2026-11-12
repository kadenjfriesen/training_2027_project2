import 'dart:convert';
import 'package:http/http.dart' as http;

const tbaApiKey = String.fromEnvironment('TBA_API_KEY');

Future<Map<String, dynamic>> fetchTeamInfo(int number) async {
  if (number <= 0) {
    throw Exception('Please enter a valid team number.');
  }

  final response = await http.get(
    Uri.parse('https://www.thebluealliance.com/api/v3/team/frc$number'),
    headers: {
      'X-TBA-Auth-Key': tbaApiKey,
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load team $number. Status code: ${response.statusCode}',
    );
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}