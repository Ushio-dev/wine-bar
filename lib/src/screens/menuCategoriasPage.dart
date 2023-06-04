import 'dart:collection';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/src/model/Mesa.dart';
import 'package:pedidos_app/src/model/TipoComida.dart';
import 'package:pedidos_app/src/providers/pedido_provider.dart';
import 'package:provider/provider.dart' as proveedor;
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MenuCategoriasPage extends StatefulWidget {
  const MenuCategoriasPage({Key? key}) : super(key: key);

  @override
  State<MenuCategoriasPage> createState() => _MenuCategoriasPageState();
}

class _MenuCategoriasPageState extends State<MenuCategoriasPage> {
  late TipoComida com;
  HashMap<String, int> pedido = HashMap();
  @override
  Widget build(BuildContext context) {
    return _getCategoriasButton(context);
  }

  Widget _getCategoriasButton(BuildContext context) {
    final mesa = ModalRoute.of(context)!.settings.arguments;
    final lista = proveedor.Provider.of<PedidoProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          actions: [
            PopupMenuButton(
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Finalizar"),
                  value: "Finalizar",
                ),
                PopupMenuItem(
                  child: Text("Borrar Todo"),
                  value: "Reiniciar",
                ),
              ],
              onSelected: (value) {
                switch(value) {
                  case "Finalizar":
                    Navigator.pushNamed(context, '/detalle', arguments: mesa);
                  break;
                  case "Reiniciar":
                    context.read<PedidoProvider>().limparPedido();
                  break;
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Color.fromARGB(255, 46, 125, 50),
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      icon: Icon(CommunityMaterialIcons.glass_cocktail),
                    ),
                    Tab(icon: Icon(CommunityMaterialIcons.coffee),)
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    // los tabs que se separan los tipos de comida
                    traerDatos(context, 'Con Alcohol'),
                    traerDatos(context, 'Confiteria')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<List<dynamic>> _getFromTitulo(String titulo, String categoria) async {
    final data = await supabase
        .from('Productos')
        .select('nombreProducto')
        .match({'titulo':titulo, 'categoria':categoria});
        //.eq('titulo', titulo);

    //print(data);
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                      future: _getFromTitulo(titulo, categoria),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
