

import 'package:flutter/material.dart';
import 'package:pedidos_app/src/model/Customer.dart';
import 'package:pedidos_app/src/model/Supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  String description;
  String number;
  DateTime date;
  //final DateTime dueDate;

  InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    //required this.dueDate,
  });
}

class InvoiceItem {
  String description;
  //final DateTime date;
  int quantity;
  //final double vat;
  double unitPrice;

  bool cancelado;

  InvoiceItem({
    required this.description,
    //required this.date,
    required this.quantity,
    //required this.vat,
    required this.unitPrice,

    required this.cancelado,
  });
}