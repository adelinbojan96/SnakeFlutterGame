import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lock the orientation to portrait for the main menu
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Game Menu',
      home: Scaffold(
        backgroundColor: Colors.lightGreenAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset(
                  'assets/images/snake_game_logo_transparent.png',
                  width: 460,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {
                      // Change the orientation to landscape when starting the game
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft,
                      ]);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 60),
                        SizedBox(width: 12),
                        Text(
                          'Play',
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Settings button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.settings, size: 60),
                        SizedBox(width: 12),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 280,  // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: () {
                      print('Exit button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.exit_to_app, size: 60),
                        SizedBox(width: 12),
                        Text(
                          'Exit',
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return Scaffold(
      body: GameWidget(
        game: MyGame(),
      ),
    );
  }
}

// MyGame will be another class in the future, a new frame
class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    print('Game loaded, initializing...');
    // Load game assets, initialize variables, etc.
  }
}
