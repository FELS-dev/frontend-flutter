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
          child: Stack(
            children: <Widget>[
              Image.asset('assets/eventMap.png'),
              Positioned(
                left: 100,
                top: 100,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
