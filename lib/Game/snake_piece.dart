import 'package:flutter/material.dart';
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

  static List<Widget> getPieces(
      List<Offset> positions, int step, int length, Color snakeColor) {
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
          color: snakeColor,
        ).toWidget(),
      );
    }

    return pieces;
  }
}