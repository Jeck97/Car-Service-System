import 'dart:convert';

class Customer {
  int id;
  String name;
  String phoneNo;
  String email;
  bool isAppUser;
  DateTime dateCreated;

  Customer(
      {this.id,
      this.name,
      this.phoneNo,
      this.email,
      this.isAppUser,
      this.dateCreated});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['customer_id'],
      name: json['name'],
      phoneNo: json['phone_no'],
      email: json['email'] != null ? json['email'] : null,
      isAppUser: json['is_app_user'],
      dateCreated: DateTime.parse(json['date_created']),
    );
  }

  static String createJson(
      {int id,
      String phoneNo,
      String email,
      String password,
      bool isAppUser,
      DateTime dateCreated}) {
    return jsonEncode(<String, dynamic>{
      'customer_id': id,
      'phone_no': phoneNo,
      'email': email,
      'password': password,
      'is_app_user': isAppUser,
      'date_created': dateCreated
    }..removeWhere((key, value) => value == null));
  }
}
