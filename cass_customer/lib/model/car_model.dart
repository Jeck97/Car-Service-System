import 'car_brand.dart';

class CarModel {
  static const String ID = 'car_model_id';
  static const String _NAME = 'car_model_name';
  static const String _TYPE = 'car_model_type';
  static const String TYPE_COMMERCIAL = 'Commercial';
  static const String TYPE_CONVERTIBLE = 'Convertible';
  static const String TYPE_COUPE = 'Coupe';
  static const String TYPE_HATCHBACK = 'Hatchback';
  static const String TYPE_MPV = 'MPV';
  static const String TYPE_PICKUP = 'Pickup';
  static const String TYPE_SEDAN = 'Sedan';
  static const String TYPE_SUV = 'SUV';
  static const String TYPE_WAGON = 'Wagon';

  int? id;
  String? name;
  String? type;
  CarBrand? carBrand;

  CarModel({
    this.id,
    this.name,
    this.type,
    this.carBrand,
  });

  factory CarModel.fromJson(Map<String, dynamic>? json) {
    return CarModel(
      id: json?[ID],
      name: json?[_NAME],
      type: json?[_TYPE],
      carBrand: CarBrand.fromJson(json),
    );
  }

  Map toJson() => {
        ID: id,
        _NAME: name,
        _TYPE: type,
        CarBrand.ID: carBrand?.id,
      };
}
