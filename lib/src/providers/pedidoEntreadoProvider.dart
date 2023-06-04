import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pedidos_app/src/model/ProductoRequest.dart';
import 'package:pedidos_app/src/screens/detalle.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PedidoEntregadoProvider with ChangeNotifier{
  List _productos = [];
  List _productosCancelados = [];
  List _productoEdit = [];

  get productos => _productos;
  get productosEdit => _productoEdit;
  int getId(int index) {
    return _productos[index]['id'];
  }
  void cargarDatos(List productos) {
    
    _productos = productos;
    
    notifyListeners();
  }

  bool getEstado (int index) {
    return _productos[index]['entregado'];
    notifyListeners();
  }

  void modificarEstado(int index, bool value) {
    _productos[index]['entregado'] = !_productos[index]['entregado'];
    notifyListeners();
  }

  void limpiarDatos() {
    _productos.clear();
    notifyListeners();
  }

  Future<void> getData(int idMesa) async {
    EasyLoading.show(status: 'Cargando');
    _productos = await supabase.from('Pedido').select('''
      id,
      producto,
      cantidad,
      entregado,
      cancelado
    ''').eq('idMesa', idMesa);
    notifyListeners();
    EasyLoading.dismiss();
  }

  get total => _productos.length;

  String traerNombre(int index) {
    return _productos[index]['producto'];
  }

  int traerCantidad(int index) {
    return _productos[index]['cantidad'];
  }

  Future<void> guardarCambios(int idMesa) async { 
    EasyLoading.show(status: 'Guardando');
    for (var elemento in _productos) {
      //final data = await supabase.rpc('update_entrega', params: {'idmesa': idMesa, 'estado':elemento['entregado'], 'prodi': elemento['producto'], 'cantidadi': elemento['cantidad']});
      final data = await supabase.from('Pedido').update({'entregado': elemento['entregado']}).eq('id', elemento['id']);
    }   
    EasyLoading.dismiss();
    Future.delayed(Duration(seconds: 1));
  }

  void cancelarPedido(int index, bool value) {
    _productos[index]['cancelado'] = value;
    notifyListeners();
  }

  bool traerEstadoCancelado(int index) {
    return _productos[index]['cancelado'];
    notifyListeners();
  }

  Future<void> cancelarPedidos() async {
    EasyLoading.show(status: "Cancelando");
    for (var elemento in _productos) {
      final data = await supabase.from('Pedido').update({'cancelado': elemento['cancelado']}).eq('id', elemento['id']);
    }
    EasyLoading.dismiss();
  }

  void limpiarCancelados() {
    /*
    int i;
    for (i = 0; i < _productosCancelados.length; i++) {
      bool band = false;
      int j = 0;
      while (!band && j < _productos.length) {
        if (_productosCancelados[i]['id'] == _productos[j]['id']) {
          band = true;
          _productos[j]['cancelado'] = !_productos[j]['cancelado'];
        }
        i++;
      }
      
    }

    _productosCancelados.clear();
    notifyListeners();
    */
  }

  bool isCancel(int index) {
    if (_productos[index]['cancelado']) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> cargarEdit(ProductoRequest productoRequest) async {
    EasyLoading.show();
    final data = await supabase.from('Pedido').update({'cantidad': productoRequest.cantidad}).eq('id', productoRequest.id);
    
    int i = 0;
    bool encontrado = false;
    while (!encontrado && i < _productos.length) {
      if (_productos[i]['id'] == productoRequest.id) {
        _productos[i]['cantidad'] == productoRequest.cantidad;
        encontrado = true;
      }
      i++;
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  Future<void> traerCantidadDb(int id) async {
    EasyLoading.show();
    final data = await supabase.from('Pedido').select('id, producto, cantidad').eq('id', id);

    _productoEdit = data;
    EasyLoading.dismiss();
  }

  void limpiarEdit() {
    _productoEdit.clear();
  }
}