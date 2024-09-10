import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        title: const Text("Options"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Welcome to the options screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
