import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'other shit.dart';

//the main function
void main() {
  runApp(ProviderScope(child: ScoutingApp()));
}

//the actual app
class ScoutingApp extends ConsumerWidget {
  const ScoutingApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalScore  = ref.watch(scoring);
    final isDarkMode = ref.watch(lightDark);

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Reefscape Scouting'),
          actions: const [
            Row(children: [OnOffSwitch(), SizedBox(width: 30)]),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              ModeButton(),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                ScoringButton(label: 'L1', pointValue: 2,),
                  const SizedBox(width: 20),
                  ScoringButton(label: 'L2', pointValue: 3,),
                  const SizedBox(width: 20),
                  ScoringButton(label: 'L3', pointValue: 4,),
                  const SizedBox(width: 20),
                  ScoringButton(label: 'L4', pointValue: 5,),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScoringButton(label: 'Net Algae', pointValue: 4,),
                  const SizedBox(width: 20),
                  ScoringButton(label: 'Processed Algae', pointValue: 6),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ScoringButton(label: 'Co-op', pointValue: 1),
                  const SizedBox(width: 20,),
                  ScoringButton(label: 'Full level', pointValue: 1)
              ],),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    ),
                  ),
                ],
              ),
              Text('Tele score:'),
              SizedBox(width: 20,),
              Text('Manual score:'),
              SizedBox(height: 20,),
              Text('Total scored: $totalScore'),
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
      ),
    );
  }
}