import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

import '../Menu/main_menu.dart';
import '../Tools/control_panel.dart';
import '../Tools/direction.dart';
import '../Tools/game_mode.dart';
import 'snake_piece.dart';

class GameScreen extends StatefulWidget {
  final double snakeSpeed;
  final Color snakeColor;
  final Color foodColor;
  final GameMode gameMode;

  const GameScreen({
    super.key,
    required this.snakeSpeed,
    required this.snakeColor,
    required this.foodColor,
    required this.gameMode,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}
class _GameScreenState extends State<GameScreen> {
  late List<Offset> positions;
  late int length;
  late int step;
  Direction direction = Direction.right;
  Timer? timer;
  late Offset foodPosition;
  var lowerBoundX, lowerBoundY, upperBoundX, upperBoundY;
  int score = 0;
  int highScore = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    step = 20;
    length = 1;
    positions = [const Offset(80, 100)];
    foodPosition = generateRandomObjectPosition();
    changeSpeed();

    lowerBoundX = 0.0;
    lowerBoundY = 0.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;

      upperBoundX = (screenSize.height).toDouble();
      upperBoundY = (screenSize.width - 50).toDouble();

      setState(() {});
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    timer?.cancel();
    super.dispose();
  }

  void changeSpeed() {
    if (timer != null && timer!.isActive) timer!.cancel();
    timer = Timer.periodic(
      Duration(milliseconds: 200 ~/ widget.snakeSpeed),
          (timer) {
        draw();
      },
    );
  }

  void restart() {
    if (score > highScore) {
      highScore = score;
    }

    score = 0;
    length = 1;
    positions = [const Offset(80, 100)];
    direction = getRandomDirection();

    changeSpeed();
  }

  Widget getScore() {
    return Positioned(
      top: 50.0,
      right: 40.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Score: $score",
            style: const TextStyle(fontSize: 24.0, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            "Highscore: $highScore",
            style: const TextStyle(fontSize: 20.0, color: Colors.black),
          ),
        ],
      ),
    );
  }
  void draw() async {
    if (positions.isEmpty) {
      positions.add(const Offset(80, 100));
    }

    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = await getNextPosition(positions[0]);

    if (positions[0] == foodPosition) {
      length++;
      score++;
      foodPosition = generateRandomObjectPosition(); // generate new food
      if (widget.gameMode == GameMode.bomber) {
        spawnBombs(); //spawn bombs in bomber mode
      }
    }

    // check if the snake bites its tail
    if (positions.sublist(1).contains(positions[0])) {
      if (timer != null && timer!.isActive) timer?.cancel();
      await Future.delayed(const Duration(milliseconds: 500), () => showGameOverDialog());
      return;
    }

    setState(() {}); // for update purposes
  }

  Future<Offset> getNextPosition(Offset position) async {
    Offset nextPosition = position;

    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }

    if (widget.gameMode == GameMode.classic || widget.gameMode == GameMode.bomber) {
      // Classic and Bomber modes: check for collision with walls
      if (detectCollision(nextPosition)) {
        if (timer != null && timer!.isActive) timer?.cancel();
        await Future.delayed(const Duration(milliseconds: 500), () => showGameOverDialog());
        return position;
      }
      // Bomber mode: check for collision with bombs
      if (widget.gameMode == GameMode.bomber && detectBombCollision(nextPosition)) {
        if (timer != null && timer!.isActive) timer?.cancel();
        await Future.delayed(const Duration(milliseconds: 500), () => showGameOverDialog());
        return position;
      }
    } else if (widget.gameMode == GameMode.freeSnake) {
      // Free Snake mode: wrap around edges instead of dying
      if (nextPosition.dx >= upperBoundX) {
        nextPosition = Offset(lowerBoundX, nextPosition.dy);
      } else if (nextPosition.dx <= lowerBoundX) {
        nextPosition = Offset(upperBoundX, nextPosition.dy);
      } else if (nextPosition.dy >= upperBoundY) {
        nextPosition = Offset(nextPosition.dx, lowerBoundY);
      } else if (nextPosition.dy <= lowerBoundY) {
        nextPosition = Offset(nextPosition.dx, upperBoundY);
      }
    }

    return nextPosition;
  }

  List<Offset> bombPositions = [];

  void spawnBombs() {
    bombPositions.clear();
    int bombCount = Random().nextInt(3) + 3; //spawning 3 to 5 bombs

    for (int i = 0; i < bombCount; i++) {
      Offset newBombPosition;
      do {
        newBombPosition = generateRandomObjectPosition();
      } while (positions.contains(newBombPosition) || newBombPosition == foodPosition);

      bombPositions.add(newBombPosition);
    }

    setState(() {}); // refresh UI
  }

  bool detectBombCollision(Offset position) {
    for (var bomb in bombPositions) {
      if (position == bomb) {
        return true;
      }
    }
    return false;
  }


  Offset generateRandomObjectPosition() {
    final random = Random();
    return Offset(
      random.nextInt(700 ~/ step) * step.toDouble() + step * 2,
      random.nextInt(300 ~/ step) * step.toDouble() + step * 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // game area
          Container(
            color: Colors.lightGreenAccent,
            child: Stack(
              children: [
                // snake and food
                ...Piece.getPieces(positions, step, length, widget.snakeColor),
                Piece(
                  posX: foodPosition.dx.toDouble(),
                  posY: foodPosition.dy.toDouble(),
                  size: step,
                  color: widget.foodColor,
                ).toWidget(),

                // bomber mode display
                if (widget.gameMode == GameMode.bomber)
                  ...bombPositions.map((bombPosition) {
                    return Piece(
                      posX: bombPosition.dx.toDouble(),
                      posY: bombPosition.dy.toDouble(),
                      size: step,
                      color: Colors.black, // Bombs are black
                    ).toWidget();
                  }),
                //render wall only for classic and bomber modes
                if (widget.gameMode != GameMode.freeSnake)
                  ...getWall(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: getControls(),
          ),
          getScore(),
        ],
      ),
    );
  }


  List<Widget> getWall() {
    final wall = <Widget>[];

    for (double x = lowerBoundX; x <= upperBoundX; x += step) {
      wall.add(
        Piece(
          posX: x,
          posY: lowerBoundY,
          size: step,
          color: Colors.brown,
        ).toWidget(),
      );

      wall.add(
        Piece(
          posX: x,
          posY: upperBoundY,
          size: step,
          color: Colors.brown,
        ).toWidget(),
      );
    }

    for (double y = lowerBoundY; y <= upperBoundY; y += step) {
      wall.add(
        Piece(
          posX: lowerBoundX,
          posY: y,
          size: step,
          color: Colors.brown,
        ).toWidget(),
      );

      wall.add(
        Piece(
          posX: upperBoundX,
          posY: y,
          size: step,
          color: Colors.brown,
        ).toWidget(),
      );
    }

    return wall;
  }

  Widget getControls() {
    return ControlPanel(
      onTapped: (Direction newDirection) {
        if ((direction == Direction.left && newDirection != Direction.right) ||
            (direction == Direction.right && newDirection != Direction.left) ||
            (direction == Direction.up && newDirection != Direction.down) ||
            (direction == Direction.down && newDirection != Direction.up)) {
          setState(() {
            direction = newDirection;
          });
        }
      },
    );
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }

    return false;
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("Your score: $score"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                restart();
              },
              child: const Text("Restart"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainMenu(),
                  ),
                );
              },
              child: const Text("Back to Menu"),
            ),

          ],
        );
      },
    );
  }

  Direction getRandomDirection() {
    const directions = Direction.values;
    return directions[Random().nextInt(directions.length)];
  }
}

