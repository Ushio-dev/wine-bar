import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pedidos_app/src/model/ProductoRequest.dart';
import 'package:pedidos_app/src/providers/pedidoEntreadoProvider.dart';
import 'package:provider/provider.dart';

class EditarPage extends StatefulWidget {
  EditarPage({Key? key}) : super(key: key);

  @override
  State<EditarPage> createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var producto = ModalRoute.of(context)!.settings.arguments as ProductoRequest;
    int nuevaCantidad = 0;
    int cantidad = 0;
    context.read<PedidoEntregadoProvider>().traerCantidadDb(producto.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("${producto.nombre}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Cantidad Anterior"),
                initialValue: "${context.read<PedidoEntregadoProvider>().productosEdit[0]['cantidad']}",
                enabled: false,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Nueva Cantidad"),
                keyboardType: TextInputType.number,
                onSaved: (newValue) {
                  nuevaCantidad = int.parse(newValue!);
                },
                autofocus: true,
                validator: (value) {
                  if (value!.isEmpty)
                    return "Ingrese un valor";
                },
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[800],
                ),
                onPressed: (){
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    producto.cantidad = nuevaCantidad;
                    context.read<PedidoEntregadoProvider>().cargarEdit(producto);
                    Navigator.pop(context);
                  }
                  
                }, 
                child: Text("Aceptar"),
              )
            ],
          ),
        ),
      )
    );
  }
}