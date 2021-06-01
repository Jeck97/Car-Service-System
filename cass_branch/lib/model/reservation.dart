import 'dart:ui';

import 'package:cass_branch/utils/date_utils.dart';

import 'branch.dart';
import 'car.dart';
import 'service.dart';

class Reservation {
  static const _Status STATUS = _Status();
  static const String NO_REMARK = 'No remark';
  static const String ID = 'reservation_id';
  static const String _DATETIME_RESERVED = 'reservation_datetime_reserved';
  static const String _DATETIME_TO_SERVICE = 'reservation_datetime_to_service';
  static const String _STATUS = 'reservation_status';
  static const String _REMARK = 'reservation_remark';

  int id;
  DateTime datetimeReserved;
  DateTime datetimeToService;
  String status;
  String remark;
  Car car;
  Service service;
  Branch branch;

  Reservation({
    this.id,
    this.datetimeReserved,
    this.datetimeToService,
    this.status,
    this.remark,
    this.car,
    this.service,
    this.branch,
  });

  String get dateTimeReservedString => DateUtils.fromDateTime(datetimeReserved);
  String get dateTimeToServiceString =>
      DateUtils.fromDateTime(datetimeToService);
  String get dateToServiceString => DateUtils.fromDate(datetimeToService);
  String get timeToServiceStartString => DateUtils.fromTime(datetimeToService);
  String get timeToServiceEndString => DateUtils.fromTime(
      datetimeToService.add(Duration(minutes: service.duration)));

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json[ID],
      datetimeReserved: DateUtils.toDateTime(json[_DATETIME_RESERVED]),
      datetimeToService: DateUtils.toDateTime(json[_DATETIME_TO_SERVICE]),
      status: json[_STATUS],
      remark: json[_REMARK],
      car: Car.fromJson(json),
      service: Service.fromJson(json),
      branch: Branch.fromJson(json),
    );
  }

  Map toJson() => {
        ID: id,
        _DATETIME_RESERVED: datetimeReserved.toUtc().toIso8601String(),
        _DATETIME_TO_SERVICE: datetimeToService.toUtc().toIso8601String(),
        _STATUS: status,
        _REMARK: remark,
        Car.ID: car.id,
        Service.ID: service.id,
        Branch.ID: branch.id,
      };

  Reservation copyWith({
    int id,
    DateTime datetimeReserved,
    DateTime datetimeToService,
    String status,
    String remark,
    Car car,
    Service service,
    Branch branch,
  }) =>
      Reservation(
        id: id ?? this.id,
        datetimeReserved: datetimeReserved ?? this.datetimeReserved,
        datetimeToService: datetimeToService ?? this.datetimeToService,
        status: status ?? this.status,
        remark: remark ?? this.remark,
        car: car ?? this.car,
        service: service ?? this.service,
        branch: branch ?? this.branch,
      );
}

class _Status {
  const _Status();
  String get reserved => 'Reserved';
  String get servicing => 'Servicing';
  String get serviced => 'Serviced';
  String get cancelled => 'Cancelled';

  Map<String, Color> get colors => {
        reserved: Color(0xFF2196F3),
        servicing: Color(0xFFFF9800),
        serviced: Color(0xFF4CAF50),
        cancelled: Color(0xFFF44336),
      };
}
