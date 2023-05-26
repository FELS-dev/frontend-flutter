import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../widgets/mobile_scanner.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  final qrScannerKey = GlobalKey<QRScannerWidgetState>();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String? scannedQRCode;
  bool showScanner = false;
  bool showIcon = false;
  bool iconSucces = false;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cacheQRCode(String qrCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedQRCode', qrCode);
  }

  void redirectToHomePage() {
    Duration duration = const Duration(seconds: 3);
    Timer(duration, homeNav);
  }

  void homeNav() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de connexion'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/vivatech.png'),
                if (showIcon)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        iconSucces ? 'QR Code scanné' : 'QR Code non reconnu',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Icon(
                        iconSucces ? Icons.check : Icons.warning,
                        color: iconSucces ? Colors.green : Colors.red,
                        size: 40,
                      )
                    ],
                  ).animate().fade(delay: 500.ms).scale(),
              ],
            ),
          ),

          if (showScanner)
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
                    showIcon = true;
                    if (scannedQRCode == 'vivatech') {
                      _cacheQRCode(scannedQRCode!);
                      iconSucces = true;
                      redirectToHomePage();
                    }
                  });
                },
              ),
            ),
          // Autres widgets de la page de connexion
        ],
      ),
      bottomNavigationBar: showScanner
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
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
                      showIcon = false;
                      iconSucces = false;
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
