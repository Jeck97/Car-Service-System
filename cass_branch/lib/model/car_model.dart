import 'package:cass_branch/model/car_brand.dart';

class CarModel {
  static const _Type TYPE = _Type();
  static const String ID = 'car_model_id';
  static const String _NAME = 'car_model_name';
  static const String _TYPE = 'car_model_type';

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
      id: json[ID],
      name: json[_NAME],
      type: json[_TYPE],
      carBrand: CarBrand.fromJson(json),
    );
  }

  Map toJson() => {
        ID: id,
        _NAME: name,
        _TYPE: type,
        CarBrand.ID: carBrand.id,
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
