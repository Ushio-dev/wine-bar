import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pedidos_app/src/model/Customer.dart';
import 'package:pedidos_app/src/model/Invoice.dart';
import 'package:pedidos_app/src/model/PdfApi.dart';
import 'package:pedidos_app/src/model/Supplier.dart';
import 'package:pedidos_app/src/utils/Utils.dart';


class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice, int idmesa) {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm), 
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice)
      ],
    ));
    return PdfApi.saveDocument(name: 'resto-${idmesa}.pdf', pdf: pdf);
  } 

  static Widget buildTitle(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('La Taberna', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(
        height: 0.8 * PdfPageFormat.cm
      ),
      Text(invoice.info.description),
      SizedBox(
        height: 0.8 * PdfPageFormat.cm
      )
    ],
  );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Descripcion',
      'Cantidad',
      'Precio Unidad',
      'Observaciones',
      'Total'
    ];

    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity;  //* (1 +item.vat);
      String estado = "";

      if (item.cancelado) {
        estado = "Cancelado";
      }
      return [
        item.description,
        //Utils.formatDate(item.date),
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        '${estado}',
        '\$ ${total.toStringAsFixed(2)}'
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.green300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight
      }
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
    .map((item) => item.unitPrice * item.quantity)
    .reduce((item1, item2) => item1 + item2);

    //final vatPercent = invoice.items.first.vat;
    //final vat = netTotal * vatPercent;
    final total = netTotal; //+ vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*
                buildText(
                  title: 'Net Total',
                  value: Utils.formatPrice(netTotal),
                  unite: true
                ),
                
                buildText(
                  title: 'Vat ${vatPercent * 100}%', 
                  value: Utils.formatPrice(vat),
                  unite: true
                ),
                */
                Divider(),
                buildText(
                  title: 'Total a Pagar', 
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.green400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.green400)
              ]
            )
          )
        ]
      )
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null)
        ]
      )
    );
  }

  static Widget buildHeader(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //buildSupplierAddress(invoice.supplier),
          /*
          Container(
            height: 50,
            width: 50,
            child: BarcodeWidget(
            data: invoice.info.number, 
            barcode: Barcode.qrCode(),
            ),
          )
          */
        ],
      ),
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment  .spaceBetween,
        children: [
          buildCostumerAdress(invoice.customer),
          buildInvoiceInfo(invoice.info),
        ],
      ),
    ],
  );

  static Widget buildSupplierAddress(Supplier supplier) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(supplier.address)
    ]
  );

  static Widget buildCostumerAdress(Customer customer) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
      Text(customer.address)
    ]
  );
  
  static buildInvoiceInfo(InvoiceInfo info) {
    //final paymentTerms = '${info.dueDate.difference(info.date)}';
    final titles = <String>[
      'Numero:',
      'Fecha:',
      //'Payment Terms:',
      //'Due Date:'
    ];

    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      //paymentTerms,
      //Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];
        
        return buildText(title: title, value: value, width: 200);
      })
    );
  }
}