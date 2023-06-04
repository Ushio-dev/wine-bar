import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final supabase = Supabase.instance.client;

  late Future<dynamic> agregar;
  late TextEditingController tituloController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de libro"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Ingrese nombre del libro"
                ),
                controller: tituloController,
              ),
              ElevatedButton(
                child: Text("Aceptar"),
                onPressed: () {
                  insertarTitulo();
                  final snackBar = SnackBar(
                    content: Text("Se guardo con exito"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    tituloController = TextEditingController(text: "");
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  void insertarTitulo() async {
    final data = await supabase.from('libro').insert({'titulo':tituloController.text});
    final resultado = data;

    print(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tituloController = TextEditingController();
  }
}