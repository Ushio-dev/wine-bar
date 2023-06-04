import 'package:pedidos_app/src/screens/detalle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MesasBloc {
  Stream<PostgrestFilterBuilder<dynamic>> get getMesas async* {
    final mesasBloc = supabase.rpc('bring_tables');

    yield mesasBloc;
  }
}