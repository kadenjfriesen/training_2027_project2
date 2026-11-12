import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'other_stuff.dart';
import 'user_buttons.dart';

import 'package:go_router/go_router.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'api_stuff.dart';

List<String> scoutingLog = [];

final TextEditingController _teamNumController = TextEditingController();
final TextEditingController _gameNumController = TextEditingController();

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/scoutingpage', builder: (context, state) => ScoutingPage()),
    GoRoute(path: '/logpage', builder: (context, state) => LogPage()),
  ],
);

//the main function
void main() {
  runApp(ProviderScope(child: ScoutingApp()));
}

//the app
class ScoutingApp extends ConsumerWidget {
  const ScoutingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(lightDark);
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
    );
  }
}

//home page
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.scuba_diving),
        title: const Text('Reefscape Scouting'),
        actions: [
          Row(children: [const OnOffSwitch(), const SizedBox(width: 30)]),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(style: TextStyle(fontSize: 30), 'Reefscape Scouting'),
              ],
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/scoutingpage'),
                  label: const Text('Scout'),
                  icon: const Icon(Icons.computer),
                ),
                SizedBox(width: 30),
                ElevatedButton.icon(
                  onPressed: () => context.go('/logpage'),
                  label: const Text('View log'),
                  icon: const Icon(Icons.list_alt),
                ),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            const Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [NameOfApp(), SizedBox(height: 14)]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//the scouting page
class ScoutingPage extends ConsumerWidget {
  const ScoutingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.scuba_diving),
        title: const Text('Reefscape Scouting'),
        actions: [
          Row(
            children: [
              SizedBox(width: 30),

              SizedBox(width: 30),

              OnOffSwitch(),
              SizedBox(width: 30),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(style: TextStyle(fontSize: 30), 'Scout game')],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _teamNumController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(labelText: 'Team Number'),
                    onChanged: (value) {
                      final parsedInt = int.tryParse(value) ?? 0;
                      ref.read(teamNumberProvider.notifier).update(parsedInt);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _gameNumController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(labelText: 'Game Number'),
                    onChanged: (value) {
                      final parsedInt = int.tryParse(value) ?? 0;
                      ref.read(gameNumberProvider.notifier).update(parsedInt);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ModeButton(),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScoringButton(label: 'L1', pointValue: 2),
                const SizedBox(width: 20),
                ScoringButton(label: 'L2', pointValue: 3),
                const SizedBox(width: 20),
                ScoringButton(label: 'L3', pointValue: 4),
                const SizedBox(width: 20),
                ScoringButton(label: 'L4', pointValue: 5),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScoringButton(label: 'Net Algae', pointValue: 4),
                const SizedBox(width: 20),
                ScoringButton(label: 'Processed Algae', pointValue: 6),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScoringButton(label: 'Co-op', pointValue: 1),
                const SizedBox(width: 20),
                ScoringButton(label: 'Full level', pointValue: 1),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ScoutedInfo()],
            ),
            const SizedBox(height: 30),

            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          return ConvexAppBar(
            style: TabStyle.fixed,
            backgroundColor: Colors.purple,
            items: const [
              TabItem(
                icon: Icon(Icons.undo, color: Colors.yellow),
                title: 'Undo',
              ),
              TabItem(
                icon: Icon(Icons.redo, color: Colors.yellow),
                title: 'Redo',
              ),
              TabItem(
                icon: Icon(Icons.upload, color: Colors.yellow),
                title: 'Submit',
              ),
              TabItem(
                icon: Icon(Icons.home, color: Colors.yellow),
                title: 'Home',
              ),
              TabItem(
                icon: Icon(Icons.list_alt, color: Colors.yellow),
                title: 'Log',
              ),
            ],
            onTap: (int index) async {
              switch (index) {
                case 0:
                  break;

                case 1:
                  break;

                case 2:
                  //get the current info
                  final currentScore = ref.read(scoring);
                  final currentTeamNum = ref.read(teamNumberProvider);
                  final currentGameNum = ref.read(gameNumberProvider);

                  //team info stuff
                  if (currentTeamNum <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid team number.'),
                      ),
                    );
                    break;
                  }

                  try {
                    // get info from tba
                    final teamData = await fetchTeamInfo(currentTeamNum);

                    //put all info into 1 list
                    final scoutingEntry =
                        '''
                    Team $currentTeamNum
                    Team Name: ${teamData['nickname'] ?? 'Unknown'}
                    City: ${teamData['city'] ?? 'Unknown'}
                    State: ${teamData['state_prov'] ?? 'Unknown'}
                    Country: ${teamData['country'] ?? 'Unknown'}

                    Game #$currentGameNum
                    Auto score: ${currentScore.autoScore}
                    Teleop score: ${currentScore.teleScore}
                    Total score: ${currentScore.totalScore}
                    ''';

                    // add this shit to the log
                    scoutingLog.add(scoutingEntry);

                    // reset everything
                    _teamNumController.clear();
                    _gameNumController.clear();

                    ref.invalidate(teamNumberProvider);
                    ref.invalidate(gameNumberProvider);
                    ref.invalidate(scoring);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scouting data submitted successfully!'),
                      ),
                    );
                  } catch (error) {
                    // Tell the user if the API request fails.
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to submit scouting data: $error'),
                      ),
                    );
                  }
                  break;

                case 3:
                  context.go('/');
                  break;

                case 4:
                  context.go('/logpage');
                  break;
              }
            },
          );
        },
      ),
    );
  }
}

//log page (scrollable)
class LogPage extends ConsumerWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.scuba_diving),
        title: const Text('Reefscape Scouting'),
        actions: [
          Row(children: [OnOffSwitch(), SizedBox(width: 30)]),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scouting log',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: scoutingLog.map((entry) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(entry),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          context.go('/scoutingpage'),
                                      child: Text('Scout Again'),
                                    ),
                                    SizedBox(width: 30),
                                    ElevatedButton(
                                      onPressed: () => context.go('/'),
                                      child: Text('Return Home'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                NameOfApp(),
                                SizedBox(height: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
