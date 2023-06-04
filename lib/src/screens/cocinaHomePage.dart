import 'package:flutter/material.dart';
import 'package:pedidos_app/src/model/MesaResponse.dart';
import 'package:pedidos_app/src/screens/detalle.dart';

class CocinaHomePage extends StatefulWidget {
  CocinaHomePage({Key? key}) : super(key: key);

  @override
  State<CocinaHomePage> createState() => _CocinaHomePageState();
}

class _CocinaHomePageState extends State<CocinaHomePage> {
  final mesasStream = supabase.from('Mesa').stream(primaryKey: ['id']).eq('terminado', false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Barra"),
      ),
      body: _getMesas(context),
      drawer: _getDrawer(context),
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
                leading: Icon(Icons.list_alt),
                subtitle: Text("Lista de Pedidos"),
                title: Text("Pedidos"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
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
                leading: Icon(Icons.check_box),
                subtitle: Text("Pedidos en preparacion"),
                title: Text("Barra"),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name != "/cocinaHome") {
                    Navigator.pushReplacementNamed(context, "/cocinaHome");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMesas(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: mesasStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List mesas = snapshot.data!;
            return ListView.builder(
              itemCount: mesas.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Card(
                    child: ListTile(
                      title: Text("Mesa ${mesas[index]['numeroMesa']}"),
                      onTap: () {
                        MesaResponse mesaResponse = MesaResponse(id :mesas[index]['id'] , numeroMesa: mesas[index]['numeroMesa']);
                        Navigator.pushNamed(context, "/detalleCocina", arguments: mesaResponse);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}