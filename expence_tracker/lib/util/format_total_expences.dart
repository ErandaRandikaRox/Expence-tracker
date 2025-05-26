import 'package:intl/intl.dart';

String formatTotalExpences(double totalExpences) {
  final currencey = NumberFormat.currency(symbol: '\Rs ', decimalDigits: 0);
  final formattedValue = currencey.format(totalExpences.abs());
  return totalExpences <= 0 ? formattedValue : "-$formattedValue";
}
