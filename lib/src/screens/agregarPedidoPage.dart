import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/src/model/TipoComida.dart';
import 'package:pedidos_app/src/providers/pedido_provider.dart';
import 'package:pedidos_app/src/screens/detalle.dart';
import 'package:provider/provider.dart' as proveedor;

class AgregarPedidoPage extends StatefulWidget {
  AgregarPedidoPage({Key? key}) : super(key: key);

  @override
  State<AgregarPedidoPage> createState() => _AgregarPedidoPageState();
}

class _AgregarPedidoPageState extends State<AgregarPedidoPage> {
  late TipoComida com;
  @override
  Widget build(BuildContext context) {
    return _getCategoriasButton(context);
  }


  Widget _getCategoriasButton(BuildContext context) {
    final mesa = ModalRoute.of(context)!.settings.arguments;
    final lista = proveedor.Provider.of<PedidoProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/detalle', arguments: mesa);
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              // reinicia todos los datos
              onPressed: () {
                context.read<PedidoProvider>().limparPedido();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      icon: Icon(CommunityMaterialIcons.silverware),
                    ),
                    Tab(
                      icon: Icon(CommunityMaterialIcons.pasta),
                    ),
                    Tab(
                      icon: Icon(CommunityMaterialIcons.ice_cream),
                    ),
                    Tab(
                      icon: Icon(CommunityMaterialIcons.glass_cocktail),
                    )
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    traerDatos(context, 'Entrada'),
                    traerDatos(context, 'Principal'),
                    traerDatos(context, 'Postre'),
                    traerDatos(context, 'Bebidas')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget traerDatos(BuildContext context, String categoria) {
    return FutureBuilder(
      future: _getACategorias(categoria),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List comiditas = snapshot.data!;
          Set setComidas = {};
          comiditas.forEach((element) {
            setComidas.add(element['titulo']);
          });

          return ListView.builder(
            itemCount: setComidas.length,
            itemBuilder: (BuildContext context, int index) {
              String titulo = setComidas.elementAt(index);
              return Card(
                child: ExpansionTile(
                  title: Text(titulo),
                  children: [
                    FutureBuilder(
                      future: _getFromTitulo(titulo),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List comidasTipo = snapshot.data!;
                          List<TipoComida> resumen = List.empty(growable: true);
                          comidasTipo.forEach((element) {
                            for (var entry in element.values) {
                              resumen.add(TipoComida(nombreTipo: entry));
                            }
                          });

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: resumen.length,
                            itemBuilder: (context, index) {
                              com = TipoComida(
                                  nombreTipo: resumen[index].nombreTipo);
                              return ListTile(
                                title: Text(com.nombreTipo),
                                subtitle: Text(
                                    "Cantidad: ${context.watch<PedidoProvider>().getCantidad(resumen[index].nombreTipo)}"),
                                onTap: () {
                                  setState(() {
                                    context.read<PedidoProvider>().agregar(
                                        TipoComida(
                                            nombreTipo:
                                                resumen[index].nombreTipo));
                                  });
                                },
                                onLongPress: () {
                                  context.read<PedidoProvider>().quitar(resumen[index]);                                 
                                },
                              );
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<dynamic>> _getFromTitulo(String titulo) async {
    final data = await supabase
        .from('Productos')
        .select('nombreProducto')
        .eq('titulo', titulo);

    //print(data);
    return data;
  }

  Future<List<dynamic>> _getACategorias(String categoria) async {
    final data = await supabase.from('Productos').select('''
      nombreProducto,
      categoria,
      titulo
      ''').eq('categoria', categoria);
    //print(data);

    return data;
  }
}