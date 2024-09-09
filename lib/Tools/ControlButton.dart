import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;

  const ControlButton({Key? key, required this.onPressed, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        width: 60.0,
        height: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.grey.withOpacity(0.3),
            elevation: 0.0,
            child: this.icon,
            onPressed: this.onPressed,
          ),
        ),
      ),
    );
  }
}
