import 'package:flutter/material.dart';
import 'control_button.dart';
import 'direction.dart';

class ControlPanel extends StatelessWidget {
  final void Function(Direction direction) onTapped;

  const ControlPanel({super.key, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //left arrow
        Positioned(
          bottom: 30.0,
          left: 50.0,
          child: ControlButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              onTapped(Direction.left);
            },
          ),
        ),
        // up Arrow
        Positioned(
          bottom: 100.0,
          left: 130.0,
          child: ControlButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () {
              onTapped(Direction.up);
            },
          ),
        ),
        // down Arrow
        Positioned(
          bottom: 30.0,
          left: 130.0,
          child: ControlButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: () {
              onTapped(Direction.down);
            },
          ),
        ),
        // right arrow
        Positioned(
          bottom: 30.0,
          left: 210.0,
          child: ControlButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              onTapped(Direction.right);
            },
          ),
        ),
      ],
    );
  }
}
