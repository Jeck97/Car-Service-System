class CarBrand {
  static const String ID = 'car_brand_id';
  static const String _NAME = 'car_brand_name';

  int id;
  String name;

  CarBrand({
    this.id,
    this.name,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(id: json[ID], name: json[_NAME]);
  }
}
