import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
          title: const Text('Page de navigation'),
        ),
        body: Builder(builder: (context) {
          if (_hasPermissions) {
            return _buildCompass();
          } else {
            return _buildPermissionSheet();
          }
        },),
      ),
    );
  }

  Widget _buildCompass() {
    return Container(
      child: const Text('Compass here')
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