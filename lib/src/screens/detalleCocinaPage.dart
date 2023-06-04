import 'package:flutter/material.dart';
import 'package:pedidos_app/src/model/MesaResponse.dart';
import 'package:pedidos_app/src/screens/detalle.dart';

class DetalleCocinaPage extends StatelessWidget {
  const DetalleCocinaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mesa = ModalRoute.of(context)!.settings.arguments as MesaResponse;
    final _stream = supabase.from('Pedido').stream(primaryKey: ['id']).eq('idMesa', mesa.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Mesa ${mesa.numeroMesa}"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                children: const [
                  TableRow(
                    children: [
                      TableCell(child: Text("Producto", textAlign: TextAlign.center,)),
                      TableCell(child: Text("Cantidad", textAlign: TextAlign.center,))
                    ]
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List pedidos = snapshot.data!;
                      pedidos.removeWhere((element) => element['categoria'] == 'Bebidas');
                      return ListView.builder(
                        itemCount: pedidos.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (pedidos[index]['cancelado']) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child: Text('${pedidos[index]['producto']}', style: TextStyle(color: Colors.red) ,textAlign: TextAlign.center)),
                                      TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child: Text('${pedidos[index]['cantidad']}', style: TextStyle(color: Colors.red), textAlign: TextAlign.center))
                                    ]
                                  ),
                                ],
                              ),
                            );
                          }
                          else {
                            if (!pedidos[index]['entregado']){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child: Text('${pedidos[index]['producto']}', style: TextStyle(color: Colors.black) ,textAlign: TextAlign.center)),
                                        TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child: Text('${pedidos[index]['cantidad']}', textAlign: TextAlign.center))
                                      ]
                                    ),
                                  ],
                                ),
                              );
                            }
                            else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child: 
                                          Text('${pedidos[index]['producto']}', 
                                            style: TextStyle(color: Colors.green), 
                                            textAlign: TextAlign.center,)),   
                                        TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child: 
                                            Text('${pedidos[index]['cantidad']}', 
                                              style: TextStyle(color: Colors.green),
                                              textAlign: TextAlign.center,))
                                      ]
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}