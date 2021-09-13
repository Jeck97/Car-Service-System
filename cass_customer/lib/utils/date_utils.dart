import 'package:intl/intl.dart';

class DateUtils {
  static const String _FORMAT_DATE = 'dd MMM y';
  static const String _FORMAT_TIME = 'hh:mm a';
  static const String _FORMAT_DATETIME = 'dd MMM y  hh:mm a';
  static const int MINUTES_PER_HOUR = 60;

  static DateTime? toDateTime(String? string) =>
      string != null ? DateTime.parse(string) : null;

  static String? fromDateTime(DateTime? dateTime) =>
      dateTime != null ? DateFormat(_FORMAT_DATETIME).format(dateTime) : null;

  static String? fromDate(DateTime? date) =>
      date != null ? DateFormat(_FORMAT_DATE).format(date) : null;

  static String? fromTime(DateTime? date) =>
      date != null ? DateFormat(_FORMAT_TIME).format(date) : null;

  static String fromMinutes(int time) {
    final hour = time ~/ MINUTES_PER_HOUR;
    final minute = time % MINUTES_PER_HOUR;
    String hourString;
    String minuteString;

    switch (hour) {
      case 0:
        hourString = '';
        break;
      case 1:
        hourString = '$hour hour';
        break;
      default:
        hourString = '$hour hours';
    }

    switch (minute) {
      case 0:
        minuteString = '';
        break;
      case 1:
        minuteString = '$minute minute';
        break;
      default:
        minuteString = '$minute minutes';
    }

    return '$hourString   $minuteString'.trim();
  }
}
