import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'other shit.dart';
import 'userButtons.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/scoutingpage',
      builder: (context, state) => ScoutingPage(),
    ),
    GoRoute(
      path: '/logpage',
      builder: (context, state) => LogPage()
    )
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
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
            Row(
              children: [
                const OnOffSwitch(),
                const SizedBox(width: 30),
              ],
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(style: TextStyle(fontSize: 30), 'Reefscape Scouting'),
                  SizedBox(width: 10,),
                  Icon(size: 45, Icons.home),
              ],),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(onPressed: () => context.go('/scoutingpage'), label: const Text('Scout'), icon: const Icon(Icons.computer)),
                  SizedBox(width: 30,),
                  ElevatedButton.icon(onPressed: () => context.go('/logpage'), label: const Text('View log'), icon: const Icon(Icons.list_alt)),
                ],
              ),
              const Expanded(child: SizedBox.shrink()),
              const Column(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        PeopleIcon(name: 'Bear Metal'),
                        SizedBox(height: 15),
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
        actions:  [
          Row(children: [
            IconButton(onPressed: ()=> context.go('/'), icon: Icon(Icons.home)),
            SizedBox(width: 30),
            IconButton(onPressed: ()=> context.go('/logpage'), icon: Icon(Icons.list_alt)),
            SizedBox(width: 30),
            OnOffSwitch(),
            SizedBox(width: 30)]),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(style: TextStyle(fontSize: 30), 'Scout game'),
                SizedBox(width: 10,),
                Icon(size: 45, Icons.computer),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Team Name'
                    ),
                    onChanged: (value) {
                    final teamName = value;
                    ref.read(teamNameProvider.notifier).update(teamName);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Team Number',
                    ),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Game Number',
                    ),
                    onChanged: (value) {
                      final parsedInt = int.tryParse(value) ?? 0;
                      ref.read(gameNumberProvider.notifier).update(parsedInt);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
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
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScoutedInfo(),
              ],
            ),
            const Expanded(child: SizedBox.shrink()),
            const Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      PeopleIcon(name: 'Bear Metal'),
                      SizedBox(height: 15),
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
            Row(children: [
              IconButton(onPressed: ()=> context.go('/'), icon: Icon(Icons.home)),
              SizedBox(width: 30),
              IconButton(onPressed: ()=> context.go('/scoutingpage'), icon: Icon(Icons.computer)),
              SizedBox(width: 30),
              OnOffSwitch(),
              SizedBox(width: 30)]),]
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(style: TextStyle(fontSize: 30), 'Scouting log'),
                          SizedBox(width: 10,),
                          Icon(size: 45, Icons.list_alt),
                        ],
                      ),
                      SizedBox(height: 30,),
                      const Spacer(),
                      const Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                PeopleIcon(name: 'Bear Metal'),
                                SizedBox(height: 15),
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
          }
      )
      );
  }
}