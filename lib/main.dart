import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InteractiveViewer(
          minScale: 0.1,
          maxScale: 10.0,
          scaleEnabled: true,
          child: Image.asset('assets/eventMap.png'),
        ),
      ),
    );
  }
}
