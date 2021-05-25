class CarBrand {
  int id;
  String name;

  CarBrand({
    this.id,
    this.name,
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      id: json['car_brand_id'],
      name: json['car_brand_name'],
    );
  }
}
