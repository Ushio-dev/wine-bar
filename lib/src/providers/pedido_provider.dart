import 'package:flutter/cupertino.dart';
import 'package:pedidos_app/src/model/TipoComida.dart';

class PedidoProvider with ChangeNotifier {
  List<TipoComida> _pedido = [];

  get pedido {
    return _pedido;
  }

  void cargarDatos(List<TipoComida> comdias) {
    _pedido = comdias;
  }

  void agregarPedido(int index) {
    _pedido[index].addCantidad();
    notifyListeners();
  }

  void agregar(TipoComida comida) {
    int i = 0;
    bool salida = false;
    if (_pedido.isNotEmpty) {
      while (i < _pedido.length && !salida) {
        if (_pedido[i].nombreTipo.compareTo(comida.nombreTipo) == 0) {
          salida = true;
        } else {
          i++;
        }
      }

      if (i >= _pedido.length) {
        comida.addCantidad();
        _pedido.add(comida);
      } else {
        _pedido[i].addCantidad();
      }
    } else {
      comida.addCantidad();
      _pedido.add(comida);
    }
  }

  int getCantidad(String nombre) {
    int salida = 0;
    if (_pedido.isNotEmpty) {
      for (var elemento in _pedido) {
        if (elemento.nombreTipo.compareTo(nombre) == 0) {
          salida = elemento.cantidad;
        }
      }
    }
    
    return salida;
  }

  void quitar(TipoComida comida) {
    int i = 0;
    bool salida = false;

    if (_pedido.isNotEmpty) {
      while (i < _pedido.length && !salida) {
        if (_pedido[i].nombreTipo.compareTo(comida.nombreTipo) == 0) {
          salida = true;
        } else {
          i++;
        }
      }

      if (salida) {
        _pedido[i].lessCantidad();
        if (_pedido[i].cantidad == 0)
          _pedido.removeAt(i);
        notifyListeners();
      }
    }
  }

  void limparPedido() {
    pedido.clear();
    notifyListeners();
  }

  
}
