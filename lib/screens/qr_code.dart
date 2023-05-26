import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  // IMPORTER LE QR CODE
  Future<String?> _getQRCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('cachedQRCode');
    return action;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 170)),
              Text(
                "Votre QR Code pour l'évènement",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
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
                FutureBuilder<String?>(
                  future: _getQRCode(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return QrImageView(
                        data: snapshot.data!,
                        version: QrVersions.auto,
                        size: 200.0,
                      );
                    } else {
                      // Gérer le cas où les données ne sont pas encore disponibles
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
