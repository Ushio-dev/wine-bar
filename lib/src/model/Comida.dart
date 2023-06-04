import 'package:pedidos_app/src/model/TipoComida.dart';

class Comida {
  String nombre;
  //int cantidad;
  List<TipoComida> tComidas;
  Comida({required this.nombre, required this.tComidas});

  String getNombre() {
    return this.nombre;
  }

  TipoComida getComida(int index) {
    return this.tComidas[index];
  }
}