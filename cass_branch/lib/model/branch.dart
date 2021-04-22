import 'dart:convert';

class Branch {
  int id;
  String name;
  String email;
  String location;

  Branch({this.id, this.name, this.email, this.location});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
        id: json['branch_id'],
        name: json['name'],
        email: json['email'],
        location: json['location']);
  }

  static String createJson(
      {int id, String name, String email, String password, String location}) {
    return jsonEncode(<String, dynamic>{
      'branch_id': id,
      'name': name,
      'email': email,
      'password': password,
      'location': location,
    }..removeWhere((key, value) => value == null));
  }
}
