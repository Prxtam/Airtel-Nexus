import 'package:intl/intl.dart';

class AppDateFormatter {
  static String format(DateTime dt) {
    return DateFormat("d MMM yyyy • h:mm a").format(dt.toLocal());
  }

  static String formatDateOnly(DateTime dt) {
    return DateFormat("d MMM yyyy").format(dt.toLocal());
  }
}
