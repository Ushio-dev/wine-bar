import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pedidos_app/src/model/TipoComida.dart';
import 'package:pedidos_app/src/providers/pedido_provider.dart';
import 'package:pedidos_app/src/utils/ProgressDialog.dart';
import 'package:provider/provider.dart' as proveedor;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/Mesa.dart';

final supabase = Supabase.instance.client;

class DetallePage extends StatefulWidget {
  const DetallePage({Key? key}) : super(key: key);

  @override
  State<DetallePage> createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  @override
  Widget build(BuildContext context) {
    final lista = proveedor.Provider.of<PedidoProvider>(context, listen: false);
    final mesa = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Detalle del Pedido"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              try {
                EasyLoading.show(status: 'Guardando...');
                await _savePedido(lista, mesa as Mesa);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Se guardo con exito')));
              } on PostgrestException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se pudo guardar')));
              } finally {
                EasyLoading.dismiss();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: context.watch<PedidoProvider>().pedido.length,
        itemBuilder: (BuildContext context, int index) {
          //String item = "listado[index].nombreTipo";
          TipoComida item = context.watch<PedidoProvider>().pedido[index];
          return _getComidaItem(item);
        },
      ),
    );
  }

  Widget _getComidaItem(TipoComida comida) {
    if (context.watch<PedidoProvider>().pedido.length > 0) {
      return Card(
        child: ListTile(
          title: Text(comida.nombreTipo),
          subtitle: Text(comida.cantidad.toString()),
        ),
      );
    } else {
      return Center(
        child: Text("Vacio"),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //List<TipoComida> listado = ModalRoute.of(context)!.settings.arguments as List<TipoComida>;
  }

  Future<void> _savePedido(PedidoProvider lista, Mesa mesa) async {
    try {
      if (!mesa.actualizar) {
        for (var elemento in lista.pedido) {
          final data = await supabase.rpc('insertar_actualizar', params: {
            'procedimiento': 'Insertar',
            'numeromesai': mesa.nroMesa,
            'comensalesi': mesa.cantidadClientes,
            'prodi': elemento.nombreTipo,
            'terminadoi': false,
            'cantidadi': elemento.cantidad
          });
        }
      } else {
        for (var elemento in lista.pedido) {
          final data = await supabase.rpc('insertar_actualizar', params: {
            'procedimiento': 'Actualizar',
            'numeromesai': mesa.nroMesa,
            'comensalesi': mesa.cantidadClientes,
            'prodi': elemento.nombreTipo,
            'terminadoi': false,
            'cantidadi': elemento.cantidad,
          });
        }
      }  
    } on PostgrestException catch (e) {
      print(e.message);
      print(e.code);
      throw PostgrestException(message: 'Error');
    } finally {
      lista.limparPedido();
    }
  }
}
