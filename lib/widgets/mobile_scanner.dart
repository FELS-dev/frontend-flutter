import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(List<Barcode>, Uint8List?) onDetect;

  const QRScannerWidget({Key? key, required this.onDetect}) : super(key: key);

  @override
  QRScannerWidgetState createState() => QRScannerWidgetState();
}

class QRScannerWidgetState extends State<QRScannerWidget> {
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
  }

  void startScan() {
    _scannerController.start();
  }

  void stopScan() {
    _scannerController.stop();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            widget.onDetect(barcodes, image);
          },
        ),
        Positioned(
          top: 16.0,
          left: 16.0,
          child: Column(
            children: [
              IconButton(
                onPressed: () => _scannerController.toggleTorch(),
                icon: ValueListenableBuilder(
                  valueListenable: _scannerController.torchState,
                  builder: (context, state, child) {
                    switch (state as TorchState) {
                      case TorchState.off:
                        return const Icon(Icons.flash_off, color: Colors.grey);
                      case TorchState.on:
                        return const Icon(Icons.flash_on, color: Colors.yellow);
                    }
                  },
                ),
                iconSize: 32.0,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () => _scannerController.switchCamera(),
                icon: ValueListenableBuilder(
                  valueListenable: _scannerController.cameraFacingState,
                  builder: (context, state, child) {
                    switch (state as CameraFacing) {
                      case CameraFacing.front:
                        return const Icon(Icons.camera_front);
                      case CameraFacing.back:
                        return const Icon(Icons.camera_rear);
                    }
                  },
                ),
                iconSize: 32.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
