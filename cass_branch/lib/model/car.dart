import 'car_model.dart';
import 'customer.dart';

class Car {
  int id;
  String plateNo;
  CarModel carModel;
  Customer customer;
  String dateToService;
  String dateFromService;
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

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['car_id'],
      plateNo: json['car_plate_number'],
      carModel: CarModel.fromJson(json),
      customer: Customer.fromJson(json),
      dateToService: json['car_date_to_service'],
      dateFromService: json['car_date_from_service'],
      distanceTargeted: json['car_distance_targeted'],
      distanceCompleted: json['car_distance_completed'],
    );
  }

  Map toJson() => {
        'car_id': id,
        'car_plate_number': plateNo,
        'car_model_id': carModel.id,
        'customer_id': customer.id,
        'car_date_to_service': dateToService,
        'car_date_from_service': dateFromService,
        'car_distance_targeted': distanceTargeted,
        'car_distance_completed': distanceCompleted,
      };
}
