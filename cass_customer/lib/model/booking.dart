import 'dart:ui';

import 'package:cass_customer/utils/date_utils.dart';
import 'package:flutter/material.dart' as m;

import 'branch.dart';
import 'car.dart';
import 'service.dart';

class Booking {
  static const String ID = 'reservation_id';
  static const String _DATETIME_RESERVED = 'reservation_datetime_reserved';
  static const String _DATETIME_TO_SERVICE = 'reservation_datetime_to_service';
  static const String _STATUS = 'reservation_status';
  static const String _REMARK = 'reservation_remark';

  static const String REMARK_NO_REMARK = 'No remark';

  static const String STATUS_RESERVED = 'Reserved';
  static const String STATUS_SERVICING = 'Servicing';
  static const String STATUS_SERVICED = 'Serviced';
  static const String STATUS_CANCELLED = 'Cancelled';

  static const Color COLOR_RESERVED = const Color(0xFF2196F3);
  static const Color COLOR_SERVICING = const Color(0xFFFF9800);
  static const Color COLOR_SERVICED = const Color(0xFF4CAF50);
  static const Color COLOR_CANCELLED = const Color(0xFFF44336);

  int? id;
  DateTime? datetimeReserved;
  DateTime? datetimeToService;
  String? status;
  String? remark;
  Car? car;
  Service? service;
  Branch? branch;

  Booking({
    this.id,
    this.datetimeReserved,
    this.datetimeToService,
    this.status,
    this.remark,
    this.car,
    this.service,
    this.branch,
  });

  Color getColor() {
    switch (this.status) {
      case STATUS_RESERVED:
        return COLOR_RESERVED;
      case STATUS_SERVICING:
        return COLOR_SERVICING;
      case STATUS_SERVICED:
        return COLOR_SERVICED;
      case STATUS_CANCELLED:
        return COLOR_CANCELLED;
      default:
        return COLOR_RESERVED;
    }
  }

  m.IconData getIconData() {
    switch (this.status) {
      case STATUS_SERVICED:
        return m.Icons.event_available_rounded;
      case STATUS_CANCELLED:
        return m.Icons.event_busy_rounded;
      case STATUS_RESERVED:
      case STATUS_SERVICING:
      default:
        return m.Icons.event_rounded;
    }
  }

  String? get dateTimeReservedString =>
      DateUtils.fromDateTime(datetimeReserved);
  String? get dateTimeToServiceString =>
      DateUtils.fromDateTime(datetimeToService);
  String? get dateToServiceString => DateUtils.fromDate(datetimeToService);
  String? get timeToServiceStartString => DateUtils.fromTime(datetimeToService);
  String? get timeToServiceEndString => DateUtils.fromTime(
      datetimeToService?.add(Duration(minutes: service!.duration!)));

  factory Booking.fromJson(Map<String, dynamic>? json) {
    return Booking(
      id: json?[ID],
      datetimeReserved: DateUtils.toDateTime(json?[_DATETIME_RESERVED]),
      datetimeToService: DateUtils.toDateTime(json?[_DATETIME_TO_SERVICE]),
      status: json?[_STATUS],
      remark: json?[_REMARK],
      car: Car.fromJson(json),
      service: Service.fromJson(json),
      branch: Branch.fromJson(json),
    );
  }

  Map toJson() => {
        ID: id,
        _DATETIME_RESERVED: datetimeReserved?.toIso8601String(),
        _DATETIME_TO_SERVICE: datetimeToService?.toIso8601String(),
        _STATUS: status,
        _REMARK: remark,
        Car.ID: car?.id,
        Service.ID: service?.id,
        Branch.ID: branch?.id,
      };
}
