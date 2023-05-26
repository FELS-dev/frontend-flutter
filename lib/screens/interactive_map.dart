import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:front_end/widgets/stand_card.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../widgets/mobile_scanner.dart';

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
    {'x': 0.5, 'y': 0.5},
    {'x': 0.3, 'y': 0.45},
    {'x': 0.2, 'y': 0.55},
  ];
  List<Map<String, String>> standsList = [
    {'name': 'Title 1', 'description': 'Lorem ipsum 1'},
    {'name': 'Title 2', 'description': 'Lorem ipsum 2'},
    {'name': 'Title 3', 'description': 'Lorem ipsum 3'},
  ];
  final TransformationController transformationController =
      TransformationController();
  late AnimationController animationController;
  late Animation<Matrix4> animationZoom;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  bool _hasScannedQR = false;
  bool _hasPermissions = false;
  bool showScanner = false;
  Map<String, double>? scannedPoint;

  final qrScannerKey = GlobalKey<QRScannerWidgetState>();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fetchPermissionStatus();
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
              ignoring: _hasPermissions,
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
                            title: stand['name']!,
                            text: stand['description']!,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (showScanner)
              Expanded(
                child: QRScannerWidget(
                  key: qrScannerKey,
                  onDetect: (List<Barcode> barcodes, Uint8List? image) {
                    setState(
                      () {
                        if (barcodes.isNotEmpty) {
                          var parts = barcodes[0].rawValue?.split(',');
                          if (parts!.length == 2) {
                            var x = double.tryParse(parts[0].trim());
                            var y = double.tryParse(parts[1].trim());

                            if (x != null && y != null) {
                              scannedPoint = {'x': x, 'y': y};
                              _hasScannedQR = true;
                              qrScannerKey.currentState?.stopScan();
                              showScanner = false;
                              centerAndZoomOnPoint(
                                Point(scannedPoint!['x']!, scannedPoint!['y']!),
                              );
                            }
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    showScanner = true;
                  });
                  qrScannerKey.currentState?.startScan();
                },
                child: const Icon(Icons.qr_code_scanner),
              ),
            ),
            if (_hasScannedQR && scannedPoint != null)
              Positioned(
                top: 86.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () => centerAndZoomOnPoint(
                    Point(scannedPoint!['x']!, scannedPoint!['y']!),
                  ),
                  child: const Icon(Icons.my_location),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCompass(BuildContext context) {
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
          return const Center(child: Text('Device does not have sensors'));
        }

        return Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: const Alignment(-1.0 + .5 * 2, -1.0 + .7 * 2),
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(132, 224, 224, 224),
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
                      SizedBox(
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
