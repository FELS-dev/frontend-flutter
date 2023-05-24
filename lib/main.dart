import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  final List<Map<String, double>> markers = [
    {'x': 0.4, 'y': 0.5},
    {'x': 0.3, 'y': 0.45},
  ];

  final TransformationController transformationController =
      TransformationController();
  late AnimationController animationController;
  late Animation<Matrix4> animationZoom;
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void centerAndZoomOnPoint(Point point) {
    final targetX = point.x * screenWidth;
    final targetY = point.y * screenHeight;

    final matrix = Matrix4.identity()
      ..translate(targetX, targetY)
      ..scale(7.0)
      ..translate(-targetX, -targetY);

    animationZoom = Matrix4Tween(
      begin: transformationController.value,
      end: matrix,
    ).animate(animationController);

    animationZoom.addListener(() {
      transformationController.value = animationZoom.value;
    });

    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            screenWidth = constraints.maxWidth;
            screenHeight = constraints.maxHeight;

            return InteractiveViewer(
              minScale: 0.1,
              maxScale: 10.0,
              scaleEnabled: true,
              transformationController: transformationController,
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/eventMap.png',
                    height: screenHeight,
                    width: screenWidth,
                  ),
                  // List all pins
                  ...markers.map(
                    (marker) => Positioned(
                      left: marker['x']! * screenWidth,
                      top: marker['y']! * screenHeight,
                      child: Container(
                        width: 2,
                        height: 2,
                        decoration: const BoxDecoration(
                          color: Colors.pinkAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        // Temp button for test recenter interactive viewer
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              centerAndZoomOnPoint(Point(markers[0]['x']!, markers[0]['y']!)),
          child: const Icon(Icons.zoom_in),
        ),
      ),
    );
  }
}
