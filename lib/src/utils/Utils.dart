import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  //static formatDate(DateTime date) => DateFormat.yMd().format(date);
  static formatDate(DateTime date) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = inputFormat.parse('${date.month}/${date.day}/${date.year}');
    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  } //=> DateFormat.yMd().format(date);
}