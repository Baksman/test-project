import 'package:intl/intl.dart';

extension dateExt on String {
  String get toDate {
    DateTime date = DateTime.parse(this);
    var newFormat = DateFormat("yMMMd");
    String updatedDt = newFormat.format(date);
    return updatedDt;
  }

  String get toTime {
    DateTime date = DateTime.parse(this);
    var newFormat = DateFormat("jm");
    String updatedDt = newFormat.format(date);
    return updatedDt;
  }
}