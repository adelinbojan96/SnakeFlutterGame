import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  _OptionsState createState() => _OptionsState();
}

double snakeSpeed = 1.01;
Color snakeColor = Colors.green[800]!;
Color foodColor = Colors.red;

class _OptionsState extends State<Options> {
  final List<Color> snakeColors = [
    Colors.green[800]!,
    Colors.yellow[300]!,
    Colors.orange,
    Colors.black,
    Colors.purple,
  ];

  final List<Color> foodColors = [
    Colors.red,
    Colors.yellow[700]!, // Dark Yellow
    Colors.grey,
  ];

  int selectedColorIndex = 0;
  int selectedFoodColorIndex = 0;

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
              value: snakeSpeed,
              min: 1.01,
              max: 2.0,
              divisions: 99,
              label: '${(((snakeSpeed - 1) * 100).round())}%',
              activeColor: Colors.green[800],
              inactiveColor: Colors.green[200],
              onChanged: (double value) {
                setState(() {
                  snakeSpeed = value;
                });
              },
            ),
            Text(
              'Snake speed: ${((snakeSpeed - 1) * 100).toStringAsFixed(0)}%',
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
                      snakeColor = snakeColors[selectedColorIndex];
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
              "Snake's food:",
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
                      foodColor = foodColors[selectedFoodColorIndex];
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
          ],
        ),
      ),
    );
  }
}
