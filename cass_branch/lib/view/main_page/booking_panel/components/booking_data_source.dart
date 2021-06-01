import 'package:cass_branch/model/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingDataSource extends CalendarDataSource {
  final List<Reservation> reservations;
  BookingDataSource(this.reservations) {
    this.appointments = reservations;
  }

  Reservation getReservation(int index) => reservations[index];

  @override
  DateTime getStartTime(int index) => reservations[index].datetimeToService;

  @override
  DateTime getEndTime(int index) => getStartTime(index)
      .add(Duration(minutes: reservations[index].service.duration));

  @override
  String getSubject(int index) =>
      '${reservations[index].car.plateNo} - ${reservations[index].service.name}';

  @override
  String getNotes(int index) => reservations[index].remark;

  @override
  String getLocation(int index) => reservations[index].branch.location;

  @override
  Color getColor(int index) =>
      Reservation.STATUS.colors[reservations[index].status];
}
