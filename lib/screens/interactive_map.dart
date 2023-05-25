import 'dart:math';
import 'package:flutter/material.dart';
import 'package:front_end/widgets/stand_card.dart';

void main() {
  runApp(const InteractiveMap());
}

class InteractiveMap extends StatefulWidget {
  const InteractiveMap({super.key});

  @override
  InteractiveMapState createState() => InteractiveMapState();
}

class InteractiveMapState extends State<InteractiveMap>
    with TickerProviderStateMixin {
  final List<Map<String, double>> markers = [
    {'x': 0.4, 'y': 0.5},
    {'x': 0.3, 'y': 0.45},
  ];
  List<Map<String, String>> cardData = [
    {'title': 'Title 1', 'text': 'Lorem ipsum 1'},
    {'title': 'Title 2', 'text': 'Lorem ipsum 2'},
    {'title': 'Title 3', 'text': 'Lorem ipsum 3'},
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
    return LayoutBuilder(
      builder: (context, constraints) {
        screenWidth = constraints.maxWidth;
        screenHeight = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            InteractiveViewer(
              minScale: 0.1,
              maxScale: 10.0,
              scaleEnabled: true,
              transformationController: transformationController,
              child: Image.asset(
                'assets/images/eventMap.png',
                height: screenHeight,
                width: screenWidth,
              ),
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
            Align(
              alignment: Alignment.bottomLeft,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: cardData.map((data) {
                          return ExpandableCard(
                            title: data['title']!,
                            text: data['text']!,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () => centerAndZoomOnPoint(
                    Point(markers[0]['x']!, markers[0]['y']!)),
                child: const Icon(Icons.zoom_in),
              ),
            ),
          ],
        );
      },
    );
  }
}
