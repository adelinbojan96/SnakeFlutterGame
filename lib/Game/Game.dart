import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../Tools/Direction.dart';
import '../Tools/ControlPanel.dart';

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
  int speed = 1;
  late Offset foodPosition;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    step = 20;
    length = 1;
    positions = [Offset(80, 100)];
    foodPosition = generateRandomFoodPosition();
    changeSpeed();
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
    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      draw();
    });
  }


  void restart() {

    length = 3;
    positions = [Offset(100, 100)];
    direction = Direction.right;
    foodPosition = generateRandomFoodPosition();

    changeSpeed();
  }

  void draw() async {
    if (positions.isEmpty) {
      positions.add(Offset(100, 100));
    }

    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = await getNextPosition(positions[0]);

    //check if the snake's head touches the food
    if (positions[0] == foodPosition) {
      length++;
      foodPosition = generateRandomFoodPosition();  //generate new food after eating
    }

    setState(() {});  // for update purpose
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

    return nextPosition;
  }

  Offset generateRandomFoodPosition() {
    final random = Random();
    return Offset(
      random.nextInt(400 ~/ step) * step.toDouble(),
      random.nextInt(300 ~/ step) * step.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //game area
          Container(
            color: Colors.lightGreenAccent,
            child: Stack(
              children: [
                ...Piece.getPieces(positions, step, length),
                //food
                Piece(
                  posX: foodPosition.dx.toInt(),
                  posY: foodPosition.dy.toInt(),
                  size: step,
                  color: Colors.red,  // Food color
                ).toWidget(),
              ],
            ),
          ),
          //
          Align(
            alignment: Alignment.topCenter,
            child: getControls(),
          ),
        ],
      ),
    );
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
}

class Piece {
  final int posX;
  final int posY;
  final int size;
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
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          color: Colors.green, //snake color
        ).toWidget(),
      );
    }

    return pieces;
  }
}
