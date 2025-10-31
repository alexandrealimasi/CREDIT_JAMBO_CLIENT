import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final formatter = DateFormat('dd MMM yyyy, HH:mm');
  return formatter.format(date);
}


String formatDateTimeAmPm(String isoDate) {
  try {
    final dateTime = DateTime.parse(isoDate);
    final formatter = DateFormat('yyyy-MM-dd hh:mm a'); // 12-hour format with AM/PM
    return formatter.format(dateTime);
  } catch (e) {
    return isoDate; // fallback if parsing fails
  }
}