import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidos_app/src/providers/pedido_provider.dart';
import 'package:pedidos_app/src/screens/menuCategoriasPage.dart';
import 'package:provider/provider.dart';

import '../model/Mesa.dart';

class NuevoPedidoPage extends StatefulWidget {
  NuevoPedidoPage({Key? key}) : super(key: key);

  @override
  State<NuevoPedidoPage> createState() => _NuevoPedidoPageState();
}

class _NuevoPedidoPageState extends State<NuevoPedidoPage> {

  late TextEditingController nroMesaController;
  final formKey = GlobalKey<FormState>();
  late int numeroMesa;
  late int comsales;
  late Mesa mesa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Nuevo Pedido"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Ingrese numero de mesa"),
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    numeroMesa = int.parse(newValue!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Ingrese numero de mesa";
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Ingrese cantidad de clientes"),
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    comsales = int.parse(newValue!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Ingrese cantidad de clientes";
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                onPressed: () {
                  _validateData(context);
                }, 
                child: Text("Siguiente"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.brown[400]
                  ),
                )
              ],
            ),
          ) 
        ),
      ),
    );
  }

  void _validateData(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      mesa = Mesa(nroMesa: numeroMesa, cantidadClientes: comsales, actualizar: false);
      Navigator.pushNamed(context, "/menuCategoria", arguments: mesa).then((value) => context.read<PedidoProvider>().limparPedido());
      //Navigator.pushReplacementNamed(context, '/menuCategoria', arguments: mesa);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nroMesaController = TextEditingController();
  }
}