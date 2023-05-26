import 'dart:math';
import 'package:flutter/material.dart';
import 'package:front_end/widgets/stand_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:front_end/api/api_service.dart';

import '../models/stand.dart';

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

  bool _hasPermissions = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fetchPermissionStatus();
  }

  Future<List<Stand>> fetchStands() async {
    try {
      List<Stand> stands = await ApiService().getStands();
      return stands;
    } catch (e) {
      // Gérez les erreurs ou renvoyez une liste vide si nécessaire
      print('Error fetching stands: $e');
      return [];
    }
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((value) {
      if (mounted) {
        setState(() {
          _hasPermissions = (value == PermissionStatus.granted);
        });
      }
    });
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
    return FutureBuilder<List<Stand>>(
      future: fetchStands(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement pendant que les stands sont récupérés
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Afficher un message d'erreur s'il y a une erreur lors de la récupération des stands
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Afficher le widget avec les stands une fois qu'ils sont récupérés avec succès
          List<Stand> standsList = snapshot.data!;

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
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/eventMap.png',
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
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Builder(
                      builder: (context) {
                        if (_hasPermissions) {
                          return _buildCompass(context);
                        } else {
                          return _buildPermissionSheet();
                        }
                      },
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
                              children: standsList.map((stand) {
                                return ExpandableCard(
                                  title: stand.name!,
                                  text: stand.description!,
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
        } else {
          // Afficher un message par défaut si les stands ne sont pas disponibles
          return Text('No stands available.');
        }
      },
    );
  }

  Widget _buildCompass(BuildContext context) {
    // Votre code pour construire le widget de la boussole
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error : ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        double? direction = snapshot.data!.heading;

        if (direction == null) {
          return Center(child: Text('Device does not have sensors'));
        }

        return Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: const Alignment(-1.0 + .5 * 2, -1.0 + .7 * 2),
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: const Color.fromARGB(125, 0, 0, 0),
                            width: 2.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        width: 128.0,
                        height: 128.0,
                      ),
                      Container(
                        width: 140.0,
                        height: 140.0,
                        child: Transform.rotate(
                          angle: (direction * (pi / 180) * -1),
                          child: Image.asset('assets/images/compass.png'),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      }),
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: ElevatedButton(
        child: const Text('Request permissions'),
        onPressed: () {
          Permission.locationWhenInUse.request().then((value) {
            _fetchPermissionStatus();
          });
        },
      ),
    );
  }
}
