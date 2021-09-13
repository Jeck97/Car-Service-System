import 'package:cass_branch/utils/date_utils.dart';

class Statistic {
  DateTime date;
  int count;

  Statistic({this.date, this.count});

  int get lastDays =>
      DateTime(date.year, date.month + 1).subtract(Duration(days: 1)).day;

  factory Statistic.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Statistic(
      date: DateUtils.toDateTime(json["date"]),
      count: json["count"],
    );
  }
}
