class Service {
  int id;
  String name;
  String description;
  double fee;

  Service({this.id, this.name, this.description, this.fee});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['service_id'],
      name: json['service_name'],
      description: json['service_description'],
      fee: json['service_fee'],
    );
  }

  Map toJson() => {
        'service_id': id,
        'service_name': name,
        'service_description': description,
        'service_fee': fee,
      };
}
