import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class QrPage extends StatefulWidget {
  QrPage({Key? key}) : super(key: key);

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    String url = ModalRoute.of(context)!.settings.arguments as String;
    print(url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('QR Code'),
      ),
      body: Center(
        child: BarcodeWidget(
          data: url, 
          barcode: Barcode.qrCode(),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}