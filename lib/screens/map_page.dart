import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _hasPermissions = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Page de navigation'),
        ),
        body: Builder(
          builder: (context) {
            if (_hasPermissions) {
              return _buildCompass(context);
            } else {
              return _buildPermissionSheet();
            }
          },
        ),
      ),
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
          return Center(child: Text('Device does not have sensors'));
        }

        return Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: const Alignment(-1.0 + .5 * 2, -1.0 + .9 * 2),
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: const Color.fromARGB(125, 0, 0, 0),
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        width: 128.0,
                        height: 128.0,
                      ),
                      Container(
                        width: 139.0,
                        height: 139.0,
                        child: Transform.rotate(
                          angle: (direction * (math.pi / 180) * -1),
                          child: Image.asset('assets/compass.png'),
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
