import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/mobile_scanner.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  final qrScannerKey = GlobalKey<QRScannerWidgetState>();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? scannedQRCode;
  bool showScanner = false;

  void _cacheQRCode(String qrCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedQRCode', qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de connexion'),
      ),
      body: Stack(
        children: [
          if (showScanner && scannedQRCode == null)
            Expanded(
              child: QRScannerWidget(
                key: widget.qrScannerKey,
                onDetect: (List<Barcode> barcodes, Uint8List? image) {
                  setState(() {
                    scannedQRCode =
                        barcodes.isNotEmpty ? barcodes[0].rawValue : null;
                    widget.qrScannerKey.currentState
                        ?.stopScan(); // Arrête la capture du QR code
                    showScanner = false;
                    if (scannedQRCode == 'toto') {
                      _cacheQRCode(scannedQRCode!);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (_) =>
                                  const HomePage()) // Stocke le QR code en cache
                          );
                    }
                  });
                },
              ),
            ),
          // Autres widgets de la page de connexion
          if (scannedQRCode != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: scannedQRCode!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    Text(scannedQRCode!)
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: showScanner
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF0081),
                      Color(0xFFFF00E4),
                      Color(0xFFF15700),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showScanner = true;
                    });
                    widget.qrScannerKey.currentState
                        ?.startScan(); // Action à effectuer lorsque le bouton est cliqué
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .transparent, // Utilisez une couleur transparente pour le bouton
                    elevation: 0, // Supprimez l'ombre du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
