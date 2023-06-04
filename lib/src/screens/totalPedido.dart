import 'package:flutter/material.dart';

class TotalPedido extends StatefulWidget {
  TotalPedido({Key? key}) : super(key: key);

  @override
  State<TotalPedido> createState() => _TotalPedidoState();
}

class _TotalPedidoState extends State<TotalPedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total'),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Text('dasd');
        },
      ),
    );
  }

}