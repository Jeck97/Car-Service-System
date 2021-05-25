import 'branch.dart';
import 'car.dart';
import 'service.dart';

class Reservation {
  static const _Status statuses = _Status();

  int id;
  String datetimeReserved;
  String datetimeToService;
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

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['reservation_id'],
      datetimeReserved: json['reservation_datetime_reserved'],
      datetimeToService: json['reservation_datetime_to_service'],
      status: json['reservation_status'],
      remark: json['reservation_remark'],
      car: Car.fromJson(json),
      service: Service.fromJson(json),
      branch: Branch.fromJson(json),
    );
  }

  Map toJson() => {
        'reservation_id': id,
        'reservation_datetime_reserved': datetimeReserved,
        'reservation_datetime_to_service': datetimeToService,
        'reservation_status': status,
        'reservation_remark': remark,
        'car_id': car.id,
        'service_id': service.id,
        'branch_id': branch.id,
      };
}

class _Status {
  const _Status();
  String get reserved => 'Reserved';
  String get servicing => 'Servicing';
  String get serviced => 'Serviced';
  String get cancelled => 'Cancelled';
}
