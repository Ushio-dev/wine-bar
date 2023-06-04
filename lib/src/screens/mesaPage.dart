import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pedidos_app/src/model/Mesa.dart';
import 'package:pedidos_app/src/model/MesaResponse.dart';
import 'package:pedidos_app/src/providers/pedidoEntreadoProvider.dart';
import 'package:pedidos_app/src/providers/pedido_provider.dart';
import 'package:pedidos_app/src/screens/detalle.dart';
import 'package:pedidos_app/src/widgets/personalCheckbox.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as proveedor;

class MesaPage extends StatefulWidget {
  final int arguments;
  const MesaPage(this.arguments, {Key? key}) : super(key: key);

  @override
  State<MesaPage> createState() => _MesaPageState();
}

class _MesaPageState extends State<MesaPage> {
  bool? is_checked = false; 
  var lista;
  var mesa;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Mesa"),
        actions: [
          PopupMenuButton(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Agregar"),
                value: "Agregar",
              ),
              PopupMenuItem(
                child: Text("Cancelar"),
                value: "Cancelar",
              ),
              PopupMenuItem(
                child: Text("Editar"),
                value: "Editar",
              ),
              PopupMenuItem(
                child: Text("Ir a Total"),
                value: "Total",
              ),
            ],         
            onSelected: (value) async {
              switch(value) {
                case "Agregar":
                  await _getMesa();
                    // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, "/menuCategoria", arguments: mesa).then((value) => context.read<PedidoProvider>().limparPedido());  
                break;
                case "Cancelar":
                  Navigator.pushNamed(context, "/cancelarPedidos",arguments: widget.arguments).then((value) => context.read<PedidoEntregadoProvider>().getData(widget.arguments));
                break;
                case "Total":
                  Navigator.pushNamed(context, '/generarPdf', arguments: widget.arguments);
                break;
                case "Editar":
                  Navigator.pushNamed(context, "/editarCantidad", arguments: widget.arguments).then((value) => context.read<PedidoEntregadoProvider>().getData(widget.arguments));
                break;
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              children: const [
                TableRow(
                  children: [
                    TableCell(
                      child: Text("Nombre", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    TableCell(
                      child: Text("Cantidad", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)) 
                    ),
                    TableCell
                    (child: Text("Entregado", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))
                    ),
                  ]
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder(
                future: lista,
                builder: (context, snapshot) {
                  
                    return ListView.builder(
                      itemCount: context.watch<PedidoEntregadoProvider>().total,
                      itemBuilder: (BuildContext context, int index) {
                        var color;
                        if (context.read<PedidoEntregadoProvider>().isCancel(index)) {
                          color = Colors.grey;
                        } else {
                          color = Colors.black;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            children: [
                              TableRow(
                                children:[
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Text(context.read<PedidoEntregadoProvider>().traerNombre(index), textAlign: TextAlign.center, style: TextStyle(color: color),),//Text("${pedidoMesa[index]['producto']}", textAlign: TextAlign.center)
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Text("${context.read<PedidoEntregadoProvider>().traerCantidad(index)}", textAlign: TextAlign.center, style: TextStyle(color: color)) //Text("${pedidoMesa[index]['cantidad']}", textAlign: TextAlign.center)
                                  ),
                                  TableCell(
                                    child: Checkbox(
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                      value: context.read<PedidoEntregadoProvider>().getEstado(index),
                                      onChanged: (value) {
                                        if (context.read<PedidoEntregadoProvider>().isCancel(index)) {
                                          null;
                                        }else {
                                          context.read<PedidoEntregadoProvider>().modificarEstado(index, value!);
                                        }         
                                      },
                                    )
                                    
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );    
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await context.read<PedidoEntregadoProvider>().guardarCambios(widget.arguments); 
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Se guardo con exito')));  
                  Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                }, 
                child: Text("Confirmar Entrega"),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.brown[400]
                ),
              )                 
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  // consulta el numero de mesa por id
  Future<void> _getMesa() async {
    final data = await supabase.from('Mesa').select('''numeroMesa, comensales''').eq('id', widget.arguments);
    
    mesa = Mesa(nroMesa: data[0]['numeroMesa'], cantidadClientes: data[0]['comensales'], actualizar: true);
    print(mesa);
  }
  Future<dynamic> _getPedidos(int idMesa, BuildContext context) async {
    final pedido = await supabase.from('Pedido').select('''
      producto,
      cantidad,
      entregado
    ''').eq('idMesa', idMesa);

    context.read<PedidoEntregadoProvider>().cargarDatos(pedido);
    return pedido;
  }

  Widget _getDialog(BuildContext context, int idMesa) {
    return CupertinoAlertDialog(
      title: const Text("¡Atencion!"),
      content: const Text("Esta Seguro que desea cerrar esta mesa"),
      actions: [
        TextButton(
            onPressed: () async{
              
              try {
                EasyLoading.show(status: 'Cerrando...');
                await _closeTable(idMesa);
                EasyLoading.dismiss();
                Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Se cerro con exito'))
                );
              } on PostgrestException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo cerrar'))
                );
              }
            },
            child: const Text("Si")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"))
      ],
    );
  }

  Future<void> _closeTable(int idMesa) async {
    try {
      final data = await supabase.from('Mesa').update({'terminado': true}).eq('id', idMesa);
    } on PostgrestException catch (e) {
      //EasyLoading.showError('No se pudo guardar');
      throw PostgrestException(message: 'No se pudo cerrar la mesa');
    } 
    
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
     
      lista = proveedor.Provider.of<PedidoEntregadoProvider>(context, listen: false).getData(widget.arguments);

    }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }
}