import 'package:flutter/material.dart';
import 'package:pedidos_app/src/providers/pedidoEntreadoProvider.dart';
import 'package:provider/provider.dart';

class CancelarPedidosPage extends StatefulWidget {
  CancelarPedidosPage({Key? key}) : super(key: key);

  @override
  State<CancelarPedidosPage> createState() => _CancelarPedidosPageState();
}

class _CancelarPedidosPageState extends State<CancelarPedidosPage> {
  @override
  Widget build(BuildContext context) {
    final mesa = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Cancelar Pedidos"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<PedidoEntregadoProvider>().total,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(context.read<PedidoEntregadoProvider>().traerNombre(index), textAlign: TextAlign.center),
                        ),
                        TableCell(
                          child: Text("${context.read<PedidoEntregadoProvider>().traerCantidad(index)}", textAlign: TextAlign.center),
                          verticalAlignment: TableCellVerticalAlignment.middle
                        ),
                        TableCell(
                          child: Checkbox(
                            checkColor: Colors.red,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              context.read<PedidoEntregadoProvider>().cancelarPedido(index, value!);
                            },
                            value: context.read<PedidoEntregadoProvider>().traerEstadoCancelado(index),
                          ),
                          verticalAlignment: TableCellVerticalAlignment.middle
                        ),
                      ]
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
              );
              }
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<PedidoEntregadoProvider>().cancelarPedidos();
              context.read<PedidoEntregadoProvider>().limpiarCancelados();
              //Navigator.pushReplacementNamed(context, "/mesaPage", arguments: mesa);
              Navigator.pop(context);
            }, 
            child: Text("Cancelar Pedidos"),
            style: TextButton.styleFrom(
                    backgroundColor: Colors.brown[400]
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}