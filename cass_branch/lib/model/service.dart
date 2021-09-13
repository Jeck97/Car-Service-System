import 'package:cass_branch/utils/date_utils.dart';

class Service {
  static const String ID = 'service_id';
  static const String _NAME = 'service_name';
  static const String _DESCRIPTION = 'service_description';
  static const String _FEE = 'service_fee';
  static const String _DURATION = 'service_duration';
  static const String _ENABLED = 'bs_enabled';
  static const String _COUNT = 'service_count';

  int id;
  String name;
  String description;
  double fee;
  int duration;
  bool enabled;
  int count;

  Service({
    this.id,
    this.name,
    this.description,
    this.fee,
    this.duration,
    this.enabled,
    this.count,
  });

  String get durationString => DateUtils.fromMinutes(duration);
  String get feeString => 'RM ${fee.toStringAsFixed(2)}';

  factory Service.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Service(
      id: json[ID],
      name: json[_NAME],
      description: json[_DESCRIPTION],
      fee: json[_FEE].toDouble(),
      duration: json[_DURATION],
      enabled: json[_ENABLED] != null ? json[_ENABLED] == 1 : false,
      count: json[_COUNT],
    );
  }

  Map toJson() => {
        ID: id,
        _NAME: name,
        _DESCRIPTION: description,
        _FEE: fee,
        _DURATION: duration,
        _ENABLED: enabled,
      };
}
