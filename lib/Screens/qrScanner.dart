import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:connectivity/connectivity.dart';
import 'package:durianmeter/Screens/spashSccreen.dart';
import 'package:flutter/material.dart';
import 'homeTabs.dart';
import 'dart:io' show Platform;

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).copyWith().size.height;
    double _width = MediaQuery.of(context).copyWith().size.width;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(5),
          height: _height,
          width: _width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: (result != null)
                      ? Text(
                          'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                      : Text('Scan a code'),
                ),
              ),
            ],
          )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
