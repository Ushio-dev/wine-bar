import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pedidos_app/src/providers/pedidoEntreadoProvider.dart';
import 'package:pedidos_app/src/providers/pedido_provider.dart';
import 'package:pedidos_app/src/screens/agregarPedidoPage.dart';
import 'package:pedidos_app/src/screens/cancelarPedidosPage.dart';
import 'package:pedidos_app/src/screens/cocinaHomePage.dart';
import 'package:pedidos_app/src/screens/detalle.dart';
import 'package:pedidos_app/src/screens/detalleCocinaPage.dart';
import 'package:pedidos_app/src/screens/editarPage.dart';
import 'package:pedidos_app/src/screens/menuEditar.dart';
import 'package:pedidos_app/src/screens/generarPdf.dart';
import 'package:pedidos_app/src/screens/menuCategoriasPage.dart';
import 'package:pedidos_app/src/screens/mesaPage.dart';
import 'package:pedidos_app/src/screens/nuevoPedidoPage.dart';
import 'package:pedidos_app/src/screens/pedidosPage.dart';
import 'package:pedidos_app/src/screens/qr_page.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PedidoProvider()),
        ChangeNotifierProvider(create: (context) => PedidoEntregadoProvider()),
      ],
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          "/":(context) => PedidosPage(),
          "/nuevoPedido":(context) => NuevoPedidoPage(),
          "/detalle":(context) => DetallePage(),
          "/cocinaHome":(context) => CocinaHomePage(),
          "/menuCategoria":(context) => MenuCategoriasPage(),
          "/mesaPage":(context) => MesaPage(ModalRoute.of(context)!.settings.arguments as int),
          "/agregarPedido":(context) => AgregarPedidoPage(),
          "/detalleCocina":(context) => DetalleCocinaPage(),
          "/generarPdf":(context) => GenerarPdf(),
          "/qrPage":(context) => QrPage(),
          "/cancelarPedidos":(context) => CancelarPedidosPage(),
          "/editarCantidad":(context) => EditarCantidadPage(),
          "/editar":(context) => EditarPage()
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}