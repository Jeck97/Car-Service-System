import 'package:cass_branch/utils/date_utils.dart';

import 'car_model.dart';
import 'customer.dart';

class Car {
  static const String ID = 'car_id';
  static const String _PLATE_NO = 'car_plate_number';
  static const String _DATE_TO_SERVICE = 'car_date_to_service';
  static const String _DATE_FROM_SERVICE = 'car_date_from_service';
  static const String _DISTANCE_TARGETED = 'car_distance_targeted';
  static const String _DISTANCE_COMPLETED = 'car_distance_completed';

  int id;
  String plateNo;
  CarModel carModel;
  Customer customer;
  DateTime dateToService;
  DateTime dateFromService;
  int distanceTargeted;
  int distanceCompleted;

  Car({
    this.id,
    this.plateNo,
    this.carModel,
    this.customer,
    this.dateToService,
    this.dateFromService,
    this.distanceTargeted,
    this.distanceCompleted,
  });

  String get dateToServiceString => DateUtils.fromDate(dateFromService);
  String get dateFromServiceString => DateUtils.fromDate(dateFromService);

  factory Car.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Car(
      id: json[ID],
      plateNo: json[_PLATE_NO],
      carModel: CarModel.fromJson(json),
      customer: Customer.fromJson(json),
      dateToService: DateUtils.toDateTime(json[_DATE_TO_SERVICE]),
      dateFromService: DateUtils.toDateTime(json[_DATE_FROM_SERVICE]),
      distanceTargeted: json[_DISTANCE_TARGETED],
      distanceCompleted: json[_DISTANCE_COMPLETED],
    );
  }

  Map toJson() => {
        ID: id,
        _PLATE_NO: plateNo,
        CarModel.ID: carModel.id,
        Customer.ID: customer.id,
        _DATE_TO_SERVICE: dateToService.toIso8601String(),
        _DATE_FROM_SERVICE: dateFromService.toIso8601String(),
        _DISTANCE_TARGETED: distanceTargeted,
        _DISTANCE_COMPLETED: distanceCompleted,
      };
}
