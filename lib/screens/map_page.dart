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
  double? d = 0.0;

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

  void _localDirection(double? direction) {
    setState(() {
      d = direction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Page de navigation ${d.toString()}'),
        ),
        body: Builder(
          builder: (context) {
            if (_hasPermissions) {
              return _buildCompass();
            } else {
              return _buildPermissionSheet();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error : ${snapshot.error}'); 
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }

        double? direction = snapshot.data!.heading;

        if(direction == null){
          return Center(child: Text('Device does not have sensors')); 
        }

        return Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: Image.asset('assets/compass.png'),
            )
          ),
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
