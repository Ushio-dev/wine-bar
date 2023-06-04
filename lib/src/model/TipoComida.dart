import 'package:pedidos_app/src/model/Comida.dart';

class TipoComida {
  String nombreTipo;
  int cantidad = 0;

  TipoComida({required this.nombreTipo});
  
  String getNombreTipo() {
    return nombreTipo;
  }
  int getCantidad() {
    return this.cantidad;
  }

  void addCantidad() {
    this.cantidad++;
  }

  void lessCantidad() {
    this.cantidad--;
  }  

  void pintarDatos() {
    print(nombreTipo);
    print(cantidad);
  }
}