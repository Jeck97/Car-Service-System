class Customer {
  int id;
  String name;
  String phoneNo;
  String email;
  String type;
  String datetimeRegistered;

  Customer({
    this.id,
    this.name,
    this.phoneNo,
    this.email,
    this.type,
    this.datetimeRegistered,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['customer_id'],
      name: json['customer_name'],
      phoneNo: json['customer_phone_number'],
      email: json['customer_email'],
      type: json['customer_type'],
      datetimeRegistered: json['customer_datetime_registered'],
    );
  }

  Map toJson() => {
        'customer_id': id,
        'customer_name': name,
        'customer_phone_number': phoneNo,
        'customer_email': email,
        'customer_type': type,
        'customer_datetime_registered': datetimeRegistered,
      };
}
