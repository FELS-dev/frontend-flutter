import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(48.8586476, 2.3740813),
            zoom: 17,
            maxZoom: 18,
            minZoom: 0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(48.8586476, 2.3740813),
                  width: 80,
                  height: 80,
                  builder: (context) => const FlutterLogo(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
