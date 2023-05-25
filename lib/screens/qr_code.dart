import 'package:flutter/material.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  // IMPORTER LE QR CODE
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('IMPORTER LE QR CODE'),
    );
  }
}
