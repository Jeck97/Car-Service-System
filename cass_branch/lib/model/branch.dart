class Branch {
  int id;
  String name;
  String email;
  String location;
  static Branch instance;

  Branch({this.id, this.name, this.email, this.location});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
        id: json['branch_id'],
        name: json['branch_name'],
        email: json['branch_email'],
        location: json['branch_location']);
  }

  Map toJson() => {
        'branch_id': id,
        'branch_name': name,
        'branch_email': email,
        'branch_location': location,
      };
}
