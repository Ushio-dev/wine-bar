import 'package:barcode_widget/barcode_widget.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:pedidos_app/src/model/Customer.dart';
import 'package:pedidos_app/src/model/Invoice.dart';
import 'package:pedidos_app/src/model/PdfApi.dart';
import 'package:pedidos_app/src/model/Supplier.dart';
import 'package:pedidos_app/src/screens/detalle.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../model/PdfInvoiceApi.dart';

class GenerarPdf extends StatefulWidget {
  GenerarPdf({Key? key}) : super(key: key);

  @override
  State<GenerarPdf> createState() => _GenerarPdfState();
}

class _GenerarPdfState extends State<GenerarPdf> {
  late String nombre;
  String publicUrl = "";
  double total = 0;
  double totalProducto = 0;
  @override
  Widget build(BuildContext context) {
    int idmesa = ModalRoute.of(context)!.settings.arguments as int;
    List<InvoiceItem> finalPedidos = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Generar y guardar Pdf"),
        actions: [
          IconButton(
            onPressed: () async {
              
              await _crearQR(finalPedidos, idmesa);
            
              final String publicUrl = supabase.storage.from('pdfs').getPublicUrl('archivos/resto-$idmesa.pdf');
              
              
              Navigator.pushNamed(context, "/qrPage", arguments: publicUrl);
            }, 
            icon: Icon(CommunityMaterialIcons.qrcode)
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: _getData(idmesa),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if (snapshot.hasData) {
              List pedidos = snapshot.data!;
              
              //final dueDate = date.add(Duration(days: 7));

             for (var elemento in pedidos) {
              var item = InvoiceItem(
                description: elemento['producto']['nombreProducto'],
                quantity: elemento['cantidad'],
                unitPrice: double.parse(elemento['producto']['precio'].toString()),
                cancelado: elemento['cancelado']
              );
              finalPedidos.add(item);
             }
              //finalPedidos.forEach((element) {print(element.description+"\n"+element.quantity.toString());});
              finalPedidos.forEach((element) {
                            total += (element.unitPrice * element.quantity);
                          });
              // saca los pedidos repetidos para unificarlos
              int i = 0;
              while (i < finalPedidos.length - 1) {
                int j = i+1;
                while (j < finalPedidos.length) {
                  if (finalPedidos[i].description.compareTo(finalPedidos[j].description) == 0) {
                    finalPedidos[i].quantity += finalPedidos[j].quantity;
                    finalPedidos.removeAt(j);
                  } else {
                    j++;
                  }
                }
                i++;
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: finalPedidos.length,
                        itemBuilder: (BuildContext context, int index) {
                          totalProducto = finalPedidos[index].unitPrice * finalPedidos[index].quantity;
                          
                          return ListTile(
                            title: Text("${finalPedidos[index].description}\nTotal: $totalProducto"),
                            subtitle: Text("Cantidad: ${finalPedidos[index].quantity}\nPrecio ud.: ${finalPedidos[index].unitPrice}"),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Total: $total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      ],
                    ),
                    
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.brown[400]
                          ),
                          onPressed: () async {
                            EasyLoading.show(status: 'Guardando');
                            await _crearPdf(finalPedidos, idmesa);
                            EasyLoading.dismiss();
                          }, 
                                child: Text('Generar Pdf')
                        ),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.brown[400]
                          ),
                          onPressed: () async {
                            EasyLoading.show(status: 'cerrando');
                            final data = await supabase.from('Mesa').update({'terminado': true}).eq('id', idmesa);
                            EasyLoading.dismiss();
                            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                      }, 
                      child: Text('Cerrar Mesa')
                    )
                      ],
                    ),
                    
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
            },
          ),
        ),
      );
  }

  Future<void> _crearPdf(List<InvoiceItem> finalPedidos, int idmesa) async {
    final date = DateTime.now();
    final invoice = Invoice(
      info: InvoiceInfo(
      date: date,
      //dueDate: dueDate,
      description: 'Resumen de cuenta',
      number: '$idmesa'//'${DateTime.now().year} - 9999',
    ), 
      supplier: Supplier(
      name: 'Salta Coders', 
      address: '47 Street Im Fashion Baby', 
      //paymentInfo: 'tu hermana'
    ), 
      customer: Customer(
      name: 'La Taberna', 
      address: 'Av. Gral. Güemes Sur 154',
    ), 
      items: finalPedidos
    );

    final pdfFile = await PdfInvoiceApi.generate(invoice, idmesa);
    try {
      final guardar = await supabase.storage.from('pdfs')
      .upload('archivos/resto-$idmesa.pdf', pdfFile,fileOptions: const FileOptions(cacheControl: '3600', upsert: false));
    } on StorageException catch (e) {
      if (e.statusCode == 409) {
        
        final String path = await supabase.storage.from('pdfs')
        .update('archivos/resto-$idmesa.pdf', pdfFile, fileOptions: const FileOptions(cacheControl: '3600', upsert: false)); 
      
      }
    } finally {
      PdfApi.openFile(pdfFile);
    } 
  }

  Future<void> _crearQR(List<InvoiceItem> finalPedidos, int idmesa) async {
    final date = DateTime.now();
    final invoice = Invoice(
      info: InvoiceInfo(
      date: date,
      //dueDate: dueDate,
      description: 'my Description ...',
      number: '$idmesa'//'${DateTime.now().year} - 9999',
    ), 
      supplier: Supplier(
      name: 'Franco Avendaño', 
      address: '47 Street Im Fashion Baby', 
      //paymentInfo: 'tu hermana'
    ), 
      customer: Customer(
      name: 'La Taberna', 
      address: 'Av. Gral. Güemes Sur 154',
    ), 
      items: finalPedidos
    );
    EasyLoading.show(status: 'Cargando');
    final pdfFile = await PdfInvoiceApi.generate(invoice, idmesa);
    EasyLoading.dismiss();
    try {
      final guardar = await supabase.storage.from('pdfs')
      .upload('archivos/resto-$idmesa.pdf', pdfFile,fileOptions: const FileOptions(cacheControl: '3600', upsert: false));
    } on StorageException catch (e) {
      if (e.statusCode == 409) {
        final String path = await supabase.storage.from('pdfs')
        .update('archivos/resto-$idmesa.pdf', pdfFile, fileOptions: const FileOptions(cacheControl: '3600', upsert: false)); 
      }
    }  
  }

  Future<dynamic> _getData(int idMesa) async {
    final data1 = supabase.from('Pedido')
    .select('idMesa, cantidad, cancelado, producto!inner(nombreProducto, precio)').eq('idMesa', idMesa);

    return data1;
  }

  Future<File> _generarPdf() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        build: (pw.Context context) =>
            pw.Center(child: pw.Text("Hola mundo"))));
    final bytes = await pdf.save();
    final name = "hmundo.pdf";
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);

    final avatarFile = File('${dir.path}/$name');
    final String path = await supabase.storage.from('pdfs').upload(
          '${dir.path}/$name',
          avatarFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    nombre = name;
    //final String publicUrl = supabase.storage.from('pdfs').getPublicUrl('$name');
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

// storal exception 409