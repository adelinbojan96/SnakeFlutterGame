import 'package:flutter/material.dart';
import '../Tools/game_mode.dart';
import '../Tools/game_settings.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  final List<Color> snakeColors = [
    Colors.green[800]!,
    Colors.yellow[300]!,
    Colors.orange,
    Colors.pink,
    Colors.purple,
  ];

  final List<Color> foodColors = [
    Colors.red,
    Colors.yellow[700]!,
    Colors.grey,
  ];

  int selectedColorIndex = 0;
  int selectedFoodColorIndex = 0;
  int selectedGameModeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        title: const Text("Options"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Snake Speed:',
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              value: GameSettings.snakeSpeed,
              min: 1.01,
              max: 2.0,
              divisions: 99,
              label: '${(((GameSettings.snakeSpeed - 1) * 100).round())}%',
              activeColor: Colors.green[800],
              inactiveColor: Colors.green[200],
              onChanged: (double value) {
                setState(() {
                  GameSettings.snakeSpeed = value;
                });
              },
            ),
            Text(
              'Snake speed: ${((GameSettings.snakeSpeed - 1) * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            const Text(
              'Snake color:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(snakeColors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorIndex = index;
                      GameSettings.snakeColor = snakeColors[selectedColorIndex];
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: snakeColors[index],
                      border: Border.all(
                        color: selectedColorIndex == index
                            ? Colors.red[400]!
                            : Colors.transparent,
                        width: selectedColorIndex == index ? 4 : 2,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            const Text(
              "Food color:",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(foodColors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFoodColorIndex = index;
                      GameSettings.foodColor = foodColors[selectedFoodColorIndex];
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: foodColors[index],
                      border: Border.all(
                        color: selectedFoodColorIndex == index
                            ? Colors.red[300]!
                            : Colors.transparent,
                        width: selectedFoodColorIndex == index ? 4 : 2,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select Game Mode:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGameModeIndex = 0;
                      GameSettings.gameMode = GameMode.classic;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedGameModeIndex == 0
                            ? Colors.red[400]!
                            : Colors.transparent,
                        width: selectedGameModeIndex == 0 ? 4 : 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/classic.png',
                          width: 100,
                          height: 100,
                        ),
                        const Text('Classic'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGameModeIndex = 1;
                      GameSettings.gameMode = GameMode.freeSnake;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedGameModeIndex == 1
                            ? Colors.red[400]!
                            : Colors.transparent,
                        width: selectedGameModeIndex == 1 ? 4 : 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/freesnake.png',
                          width: 100,
                          height: 100,
                        ),
                        const Text('Free Snake'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGameModeIndex = 2;
                      GameSettings.gameMode = GameMode.bomber;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedGameModeIndex == 2
                            ? Colors.red[400]!
                            : Colors.transparent,
                        width: selectedGameModeIndex == 2 ? 4 : 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/bomber.png',
                          width: 100,
                          height: 100,
                        ),
                        const Text('Bomber'),
                      ],
                    ),
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
