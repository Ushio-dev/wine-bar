import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pedidos_app/src/model/ProductoRequest.dart';
import 'package:pedidos_app/src/providers/pedidoEntreadoProvider.dart';
import 'package:provider/provider.dart';

class EditarCantidadPage extends StatefulWidget {
  EditarCantidadPage({Key? key}) : super(key: key);

  @override
  State<EditarCantidadPage> createState() => _EditarCantidadPageState();
}

class _EditarCantidadPageState extends State<EditarCantidadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Editar Cantidad"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: context.read<PedidoEntregadoProvider>().total,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text("${context.read<PedidoEntregadoProvider>().traerNombre(index)}"),
                    onTap: () async {
                      ProductoRequest productoRequest = ProductoRequest(
                        id: context.read<PedidoEntregadoProvider>().getId(index), 
                        nombre: context.read<PedidoEntregadoProvider>().traerNombre(index), 
                        cantidad: context.read<PedidoEntregadoProvider>().traerCantidad(index)
                      );
                      EasyLoading.show();
                      await context.read<PedidoEntregadoProvider>().traerCantidadDb(productoRequest.id);
                      EasyLoading.dismiss();
                      Navigator.pushNamed(context, "/editar", arguments: productoRequest).then((value) => context.read<PedidoEntregadoProvider>().limpiarEdit());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}