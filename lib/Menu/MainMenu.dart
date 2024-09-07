import 'package:flutter/material.dart';
import '../Game/Game.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Menu',
      home: Scaffold(
        backgroundColor: Colors.lightGreenAccent,
        body: SafeArea(
          child: Center(
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
                // Play Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 280,
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {

                            print('Play button pressed');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GameScreen(),
                              ),
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
                        );
                      },
                    ),
                  ),
                ),
                // Settings Button
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
                // Exit Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 280,
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
      ),
    );
  }
}
