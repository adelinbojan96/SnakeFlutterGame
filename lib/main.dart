import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainMenu());
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Menu',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 280,  // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 50),
                        SizedBox(width: 10),  // Space between icon and text
                        Text('Play'),
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
                      // Navigate to the settings screen (not implemented in this example)
                      print('Settings button pressed');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.settings, size: 50),
                        SizedBox(width: 10),  // Space between icon and text
                        Text('Settings'),
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
                      // Exit the app
                      print('Exit button pressed');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.exit_to_app, size: 50),
                        SizedBox(width: 10),  // Space between icon and text
                        Text('Exit'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MyGame(),
      ),
    );
  }
}

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    print('Game loaded, initializing...');
    // Load your game assets, initialize variables, etc.
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Render your game elements
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update game state
  }
}
