class Branch {
  static const String ID = 'branch_id';
  static const String _NAME = 'branch_name';
  static const String _EMAIL = 'branch_email';
  static const String _LOCATION = 'branch_location';

  int id;
  String name;
  String email;
  String location;
  static Branch instance;

  Branch({this.id, this.name, this.email, this.location});

  factory Branch.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Branch(
        id: json[ID],
        name: json[_NAME],
        email: json[_EMAIL],
        location: json[_LOCATION]);
  }

  Map toJson() => {
        ID: id,
        _NAME: name,
        _EMAIL: email,
        _LOCATION: location,
      };
}
