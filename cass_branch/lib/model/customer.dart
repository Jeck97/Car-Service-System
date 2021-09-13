import 'package:cass_branch/utils/date_utils.dart';

class Customer {
  static const _Type TYPE = _Type();
  static const String ID = 'customer_id';
  static const String _NAME = 'customer_name';
  static const String _PHONE_NO = 'customer_phone_number';
  static const String _EMAIL = 'customer_email';
  static const String _PASSWORD = 'customer_password';
  static const String _TYPE = 'customer_type';
  static const String _DATETIME_REGISTERED = 'customer_datetime_registered';

  int id;
  String name;
  String phoneNo;
  String email;
  String password;
  String type;
  DateTime datetimeRegistered;

  Customer({
    this.id,
    this.name,
    this.phoneNo,
    this.email,
    this.password,
    this.type,
    this.datetimeRegistered,
  });

  String get datetimeRegisteredString =>
      DateUtils.fromDateTime(datetimeRegistered);

  factory Customer.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Customer(
      id: json[ID],
      name: json[_NAME],
      phoneNo: json[_PHONE_NO],
      email: json[_EMAIL],
      type: json[_TYPE],
      datetimeRegistered: DateUtils.toDateTime(json[_DATETIME_REGISTERED]),
    );
  }

  Map toJson() => {
        ID: id,
        _NAME: name,
        _PHONE_NO: phoneNo,
        _EMAIL: email,
        _PASSWORD: password,
        _TYPE: type,
        _DATETIME_REGISTERED: datetimeRegistered.toIso8601String(),
      };
}

class _Type {
  const _Type();
  String get normalUser => 'Normal User';
  String get appUser => 'App User';
}
