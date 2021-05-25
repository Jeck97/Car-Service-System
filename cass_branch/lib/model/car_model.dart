import 'package:cass_branch/model/car_brand.dart';

class CarModel {
  static const _Type types = _Type();

  int id;
  String name;
  String type;
  CarBrand carBrand;

  CarModel({
    this.id,
    this.name,
    this.type,
    this.carBrand,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['car_model_id'],
      name: json['car_model_name'],
      type: json['car_model_type'],
      carBrand: CarBrand.fromJson(json),
    );
  }

  Map toJson() => {
        'car_model_id': id,
        'car_model_name': name,
        'car_model_type': type,
        'car_brand_id': carBrand.id,
      };
}

class _Type {
  const _Type();
  String get commercial => 'Commercial';
  String get convertible => 'Convertible';
  String get coupe => 'Coupe';
  String get hatchback => 'Hatchback';
  String get mpv => 'MPV';
  String get pickup => 'Pickup';
  String get sedan => 'Sedan';
  String get suv => 'SUV';
  String get wagon => 'Wagon';
}
