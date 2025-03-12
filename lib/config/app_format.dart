import 'package:intl/intl.dart';

class AppFormat {
  static String shortPrice(num number) {
    return NumberFormat.compactCurrency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(number);
  }

  static String longPrice(num number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(number);
  }

  static String date(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// DateTime | String
  /// Monday, 2 Mar 25
  static String shortDate(dateTime) {
    switch (dateTime.runtimeType) {
      case String:
        return DateFormat('EEEE, d MMM yy').format(DateTime.parse(dateTime));
      case DateTime:
        return DateFormat('EEEE, d MMM yy').format(dateTime);
      default:
        return 'Invalid';
    }
  }

  /// DateTime | String
  /// Monday, 2 March 2025
  static String fullDate(dateTime) {
    switch (dateTime.runtimeType) {
      case String:
        return DateFormat('EEEE, d MMM yy').format(DateTime.parse(dateTime));
      case DateTime:
        return DateFormat('EEEE, d MMM yy').format(dateTime);
      default:
        return 'Invalid';
    }
  }
}
