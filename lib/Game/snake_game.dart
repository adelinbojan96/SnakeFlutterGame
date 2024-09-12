import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../Menu/main_menu.dart';
import '../Tools/direction.dart';
import '../Tools/control_panel.dart';
import '../Menu/options.dart';
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

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
    foodPosition = generateRandomFoodPosition();
    changeSpeed();

    lowerBoundX = 0.0;
    lowerBoundY = 0.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery
          .of(context)
          .size;

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
    //cancel previous timer if it's running
    if (timer != null && timer!.isActive) timer!.cancel();

    //restart the timer with the new speed
    timer = Timer.periodic(Duration(milliseconds: 200 ~/ snakeSpeed), (timer) {
      draw();
    });
  }


  void restart() {
    score = 0;
    length = 1;
    positions = [const Offset(80, 100)];
    direction = getRandomDirection();
    snakeSpeed = 1;

    changeSpeed();
  }

  Widget getScore() {
    return Positioned(
      top: 50.0,
      right: 40.0,
      child: Text(
        "Score: $score",
        style: const TextStyle(fontSize: 24.0, color: Colors.black),
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
      foodPosition = generateRandomFoodPosition(); //generate new food
    }

    setState(() {}); //for update purposes
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
    if (detectCollision(nextPosition) == true) {
      if (timer != null && timer!.isActive) timer?.cancel();
      await Future.delayed(
          const Duration(milliseconds: 500), () => showGameOverDialog());
      return position;
    }
    return nextPosition;
  }


  Offset generateRandomFoodPosition() {
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
                ...Piece.getPieces(positions, step, length),
                Piece(
                  posX: foodPosition.dx.toDouble(),
                  posY: foodPosition.dy.toDouble(),
                  size: step,
                  color: Colors.red,
                ).toWidget(),
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


//generate wall around the margins of the screen using bounds
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


    for (double y = lowerBoundY; y <= upperBoundY;
    y += step) {

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
class Piece {
  final double posX;
  final double posY;
  final size;
  final Color color;

  Piece({
    required this.posX,
    required this.posY,
    required this.size,
    required this.color,
  });

  //converting Piece into a Positioned widget
  Widget toWidget() {
    return Positioned(
      left: posX.toDouble(),
      top: posY.toDouble(),
      child: Container(
        width: size.toDouble(),
        height: size.toDouble(),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  //method to return a list of widgets (snake and food)
  static List<Widget> getPieces(List<Offset> positions, int step, int length) {
    final pieces = <Widget>[];

    for (var i = 0; i < length; i++) {
      if (i >= positions.length) {
        continue;
      }

      pieces.add(
        Piece(
          posX: positions[i].dx.toDouble(),
          posY: positions[i].dy.toDouble(),
          size: step,
          color: Colors.green, //snake color
        ).toWidget(),
      );
    }

    return pieces;
  }
}
