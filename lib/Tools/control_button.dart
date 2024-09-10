import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;

  const ControlButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.grey.withOpacity(0.3),
            elevation: 0.0,
            onPressed: onPressed,
            child: icon,
          ),
        ),
      ),
    );
  }
}
