import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pedidos_app/src/model/MesaResponse.dart';
import 'package:pedidos_app/src/providers/pedidoEntreadoProvider.dart';
import 'package:pedidos_app/src/screens/detalle.dart';
import 'package:pedidos_app/src/screens/mesaPage.dart';
import 'package:pedidos_app/src/screens/nuevoPedidoPage.dart';
import 'package:provider/provider.dart' as proveedor;

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  List<int> pedidos = List.empty(growable: true);
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
        backgroundColor: Colors.brown[400],
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                
              });
            }, 
            icon: const Icon(CommunityMaterialIcons.refresh))
        ],
      ),
      drawer: _getDrawer(context),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _getTables(),
              builder: (context, snapshot) {

                  if (snapshot.hasData) {
                    final lista = snapshot.data!;
                    return ListView.builder(
                      itemCount: lista.length,
                      itemBuilder: (BuildContext context, int index) {
                        MesaResponse mesa = MesaResponse(id: lista[index]['id'], numeroMesa: lista[index]['numeroMesa']);
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text("Mesa: ${mesa.numeroMesa}"),
                            onTap: () {
                              Navigator.pushNamed(context, "/mesaPage", arguments: mesa.id).then((value) => context.read<PedidoEntregadoProvider>().limpiarDatos());
                            },
                            trailing: Icon(CommunityMaterialIcons.arrow_right),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[400],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("/nuevoPedido");
        },
      ),
    );
  }

  Widget _getDrawer(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(222, 230, 249, 0),
                  image: DecorationImage(
                    image: AssetImage("assets/wine.jpg"),
                    fit: BoxFit.cover
                  ),
                ),
                child: null),
            Container(
              child: ListTile(
                leading: const Icon(Icons.list_alt),
                subtitle: const Text("Lista de Pedidos"),
                title: const Text("Pedidos"),
                onTap: () {
                  // verifica si estoy en la misma pantalla, para no volver a cargarla
                  if (ModalRoute.of(context)?.settings.name != "/") {
                    Navigator.pushReplacementNamed(context, "/");
                  }
                },
              ),
            ),
            const Divider(
              height: 1,
              thickness: 2,
              color: Colors.grey,
            ),
            Container(
              child: ListTile(
                leading: const Icon(Icons.check_box),
                subtitle: const Text("Pedidos a preparar"),
                title: const Text("Barra"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/cocinaHome");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDialog(BuildContext context, int index) {
    return CupertinoAlertDialog(
      title: const Text("¡Atencion!"),
      content: const Text("Esta Seguro que desea eleminar esta mesa"),
      actions: [
        TextButton(
            onPressed: () {
              _deleteTable();
              setState(() {});
              Navigator.pop(context);
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

  void _deleteTable() async {
    final data = await supabase
      .from('Mesa')
      .delete()
      .match({ 'id': 666 });
  }
  Future<dynamic> _getTables() {
    final data = supabase.rpc('bring_tables');

    return data;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
}
