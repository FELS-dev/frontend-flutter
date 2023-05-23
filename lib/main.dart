import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Temp pins map data
    final List<Map<String, double>> markers = [
      {'x': 50.0, 'y': 360.0},
      {'x': 300.0, 'y': 420.0},
    ];

    final TransformationController transformCtrl = TransformationController();

    void centerAndZoomOnPoint(Point point) {
      final matrix = Matrix4.identity()
        ..translate(-point.x, 0, -point.y.toDouble())
        ..scale(2.0);
      transformCtrl.value = matrix;
    }

    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: InteractiveViewer(
            minScale: 0.1,
            maxScale: 10.0,
            scaleEnabled: true,
            transformationController: transformCtrl,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'assets/eventMap.png',
                  height: double.infinity,
                  width: double.infinity,
                ),
                // List all pins
                ...markers.map(
                  (marker) => Positioned(
                    left: marker['x'],
                    top: marker['y'],
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Temp button for test recenter interactive viewer
        floatingActionButton: FloatingActionButton(
          onPressed: () => centerAndZoomOnPoint(const Point(50.0, 360.0)),
          child: const Icon(Icons.zoom_in),
        ),
      ),
    );
  }
}
